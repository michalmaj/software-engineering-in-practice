import static org.junit.jupiter.api.Assertions.assertEquals;

import com.google.gson.Gson;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Map;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class ApiServerTest {

    private static final Gson GSON = new Gson();
    private static final HttpClient CLIENT = HttpClient.newHttpClient();

    private HttpServer server;
    private String baseUrl;

    @BeforeEach
    void startServer() throws IOException {
        server = ApiServer.createServer(0);
        server.start();
        baseUrl = "http://localhost:" + server.getAddress().getPort();
    }

    @AfterEach
    void stopServer() {
        server.stop(0);
    }

    @Test
    void postThenGetOrder() throws Exception {
        HttpRequest postRequest = HttpRequest.newBuilder(URI.create(baseUrl + "/orders"))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString("{\"items\": [\"Burger\"]}"))
                .build();
        HttpResponse<String> postResponse = CLIENT.send(postRequest, HttpResponse.BodyHandlers.ofString());
        assertEquals(201, postResponse.statusCode());

        Map<?, ?> created = GSON.fromJson(postResponse.body(), Map.class);
        String orderId = (String) created.get("order_id");

        HttpRequest getRequest = HttpRequest.newBuilder(URI.create(baseUrl + "/orders/" + orderId)).GET().build();
        HttpResponse<String> getResponse = CLIENT.send(getRequest, HttpResponse.BodyHandlers.ofString());
        assertEquals(200, getResponse.statusCode());

        Map<?, ?> fetched = GSON.fromJson(getResponse.body(), Map.class);
        assertEquals("received", fetched.get("status"));
    }

    @Test
    void getMissingOrderReturns404() throws Exception {
        HttpRequest request = HttpRequest.newBuilder(URI.create(baseUrl + "/orders/does-not-exist")).GET().build();
        HttpResponse<String> response = CLIENT.send(request, HttpResponse.BodyHandlers.ofString());
        assertEquals(404, response.statusCode());
    }

    @Test
    void postWithoutItemsReturns400() throws Exception {
        HttpRequest request = HttpRequest.newBuilder(URI.create(baseUrl + "/orders"))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString("{}"))
                .build();
        HttpResponse<String> response = CLIENT.send(request, HttpResponse.BodyHandlers.ofString());
        assertEquals(400, response.statusCode());
    }
}
