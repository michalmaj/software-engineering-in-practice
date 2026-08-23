import json
from http.server import BaseHTTPRequestHandler, HTTPServer

ORDERS: dict[str, dict] = {}
NEXT_ID = 1


class OrderHandler(BaseHTTPRequestHandler):
    def _send_json(self, status: int, payload: dict) -> None:
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self) -> None:
        if self.path.startswith("/orders/"):
            order_id = self.path.removeprefix("/orders/")
            order = ORDERS.get(order_id)
            if order is None:
                self._send_json(404, {"error": "order not found"})
                return
            self._send_json(200, order)
            return
        self._send_json(404, {"error": "not found"})

    def do_POST(self) -> None:
        global NEXT_ID
        if self.path == "/orders":
            length = int(self.headers.get("Content-Length", 0))
            raw = self.rfile.read(length)
            try:
                data = json.loads(raw)
            except json.JSONDecodeError:
                self._send_json(400, {"error": "invalid JSON"})
                return
            items = data.get("items")
            if not isinstance(items, list) or not items:
                self._send_json(400, {"error": "items must be a non-empty list"})
                return
            order_id = str(NEXT_ID)
            NEXT_ID += 1
            order = {"order_id": order_id, "items": items, "status": "received"}
            ORDERS[order_id] = order
            self._send_json(201, order)
            return
        self._send_json(404, {"error": "not found"})

    def log_message(self, format: str, *args) -> None:
        pass  # quiet during tests; Lab 24 replaces this with real logging


def run(port: int = 8000) -> None:
    server = HTTPServer(("localhost", port), OrderHandler)
    print(f"order-api listening on http://localhost:{port}")
    server.serve_forever()


if __name__ == "__main__":
    run()
