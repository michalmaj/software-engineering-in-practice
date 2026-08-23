import json
import threading

import pytest
from http.client import HTTPConnection
from http.server import HTTPServer

from api import ORDERS, OrderHandler


@pytest.fixture()
def server_port():
    ORDERS.clear()
    httpd = HTTPServer(("localhost", 0), OrderHandler)
    port = httpd.server_port
    thread = threading.Thread(target=httpd.serve_forever, daemon=True)
    thread.start()
    yield port
    httpd.shutdown()
    thread.join()


def test_post_then_get_order(server_port):
    conn = HTTPConnection("localhost", server_port)
    conn.request(
        "POST",
        "/orders",
        body=json.dumps({"items": ["Burger"]}),
        headers={"Content-Type": "application/json"},
    )
    response = conn.getresponse()
    assert response.status == 201
    created = json.loads(response.read())
    order_id = created["order_id"]

    conn.request("GET", f"/orders/{order_id}")
    response = conn.getresponse()
    assert response.status == 200
    fetched = json.loads(response.read())
    assert fetched["status"] == "received"


def test_get_missing_order_returns_404(server_port):
    conn = HTTPConnection("localhost", server_port)
    conn.request("GET", "/orders/does-not-exist")
    response = conn.getresponse()
    assert response.status == 404


def test_post_without_items_returns_400(server_port):
    conn = HTTPConnection("localhost", server_port)
    conn.request(
        "POST",
        "/orders",
        body=json.dumps({}),
        headers={"Content-Type": "application/json"},
    )
    response = conn.getresponse()
    assert response.status == 400
