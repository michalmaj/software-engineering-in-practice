import com.sun.net.httpserver.HttpServer;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException {
        int port = Integer.parseInt(System.getenv().getOrDefault("PORT", "8000"));

        HttpServer server = ApiServer.createServer(port);
        System.out.println("order-api listening on http://localhost:" + port);
        server.start();
    }
}
