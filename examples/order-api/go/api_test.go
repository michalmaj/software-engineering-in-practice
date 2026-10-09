package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func newTestServer() *httptest.Server {
	mu.Lock()
	orders = map[string]Order{}
	nextID = 1
	mu.Unlock()
	return httptest.NewServer(newMux())
}

func TestPostThenGetOrder(t *testing.T) {
	server := newTestServer()
	defer server.Close()

	resp, err := http.Post(server.URL+"/orders", "application/json", strings.NewReader(`{"items": ["Burger"]}`))
	if err != nil {
		t.Fatalf("POST failed: %v", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusCreated {
		t.Fatalf("got status %d, want %d", resp.StatusCode, http.StatusCreated)
	}
	var created Order
	if err := json.NewDecoder(resp.Body).Decode(&created); err != nil {
		t.Fatalf("decode failed: %v", err)
	}

	getResp, err := http.Get(server.URL + "/orders/" + created.OrderID)
	if err != nil {
		t.Fatalf("GET failed: %v", err)
	}
	defer getResp.Body.Close()
	if getResp.StatusCode != http.StatusOK {
		t.Fatalf("got status %d, want %d", getResp.StatusCode, http.StatusOK)
	}
	var fetched Order
	if err := json.NewDecoder(getResp.Body).Decode(&fetched); err != nil {
		t.Fatalf("decode failed: %v", err)
	}
	if fetched.Status != "received" {
		t.Errorf("got status %q, want %q", fetched.Status, "received")
	}
}

func TestGetMissingOrderReturns404(t *testing.T) {
	server := newTestServer()
	defer server.Close()

	resp, err := http.Get(server.URL + "/orders/does-not-exist")
	if err != nil {
		t.Fatalf("GET failed: %v", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusNotFound {
		t.Errorf("got status %d, want %d", resp.StatusCode, http.StatusNotFound)
	}
}

func TestPostWithoutItemsReturns400(t *testing.T) {
	server := newTestServer()
	defer server.Close()

	resp, err := http.Post(server.URL+"/orders", "application/json", strings.NewReader(`{}`))
	if err != nil {
		t.Fatalf("POST failed: %v", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusBadRequest {
		t.Errorf("got status %d, want %d", resp.StatusCode, http.StatusBadRequest)
	}
}
