import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

public class ApiServer implements HttpHandler {

    private static final Gson GSON = new Gson();

    private final Map<String, Order> orders = new ConcurrentHashMap<>();
    private final AtomicInteger nextId = new AtomicInteger(1);

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        String method = exchange.getRequestMethod();
        String path = exchange.getRequestURI().getPath();

        if ("POST".equals(method) && "/orders".equals(path)) {
            handleCreateOrder(exchange);
        } else if ("GET".equals(method) && path.startsWith("/orders/")) {
            handleGetOrder(exchange, path.substring("/orders/".length()));
        } else {
            writeError(exchange, 404, "not found");
        }
    }

    private void handleCreateOrder(HttpExchange exchange) throws IOException {
        String body = new String(exchange.getRequestBody().readAllBytes(), StandardCharsets.UTF_8);

        Map<?, ?> data;
        try {
            data = GSON.fromJson(body, Map.class);
        } catch (JsonSyntaxException e) {
            writeError(exchange, 400, "invalid JSON");
            return;
        }
        if (data == null) {
            writeError(exchange, 400, "invalid JSON");
            return;
        }

        Object itemsRaw = data.get("items");
        if (!(itemsRaw instanceof List<?> items) || items.isEmpty()) {
            writeError(exchange, 400, "items must be a non-empty list");
            return;
        }

        String id = String.valueOf(nextId.getAndIncrement());
        @SuppressWarnings("unchecked")
        Order order = new Order(id, (List<Object>) items, "received");
        orders.put(id, order);

        writeJson(exchange, 201, order);
    }

    private void handleGetOrder(HttpExchange exchange, String id) throws IOException {
        Order order = orders.get(id);
        if (order == null) {
            writeError(exchange, 404, "order not found");
            return;
        }
        writeJson(exchange, 200, order);
    }

    private void writeJson(HttpExchange exchange, int status, Object payload) throws IOException {
        byte[] body = GSON.toJson(payload).getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().add("Content-Type", "application/json");
        exchange.sendResponseHeaders(status, body.length);
        try (OutputStream os = exchange.getResponseBody()) {
            os.write(body);
        }
    }

    private void writeError(HttpExchange exchange, int status, String message) throws IOException {
        writeJson(exchange, status, Map.of("error", message));
    }

    public static HttpServer createServer(int port) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress("localhost", port), 0);
        server.createContext("/", new ApiServer());
        return server;
    }
}
