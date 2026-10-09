package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strconv"
	"sync"
)

type Order struct {
	OrderID string `json:"order_id"`
	Items   []any  `json:"items"`
	Status  string `json:"status"`
}

var (
	mu     sync.Mutex
	orders = map[string]Order{}
	nextID = 1
)

func writeJSON(w http.ResponseWriter, status int, payload any) {
	body, _ := json.Marshal(payload)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	w.Write(body)
}

func writeError(w http.ResponseWriter, status int, message string) {
	writeJSON(w, status, map[string]string{"error": message})
}

func handleCreateOrder(w http.ResponseWriter, r *http.Request) {
	var body map[string]any
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		writeError(w, http.StatusBadRequest, "invalid JSON")
		return
	}

	items, ok := body["items"].([]any)
	if !ok || len(items) == 0 {
		writeError(w, http.StatusBadRequest, "items must be a non-empty list")
		return
	}

	mu.Lock()
	id := strconv.Itoa(nextID)
	nextID++
	order := Order{OrderID: id, Items: items, Status: "received"}
	orders[id] = order
	mu.Unlock()

	writeJSON(w, http.StatusCreated, order)
}

func handleGetOrder(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")

	mu.Lock()
	order, found := orders[id]
	mu.Unlock()

	if !found {
		writeError(w, http.StatusNotFound, "order not found")
		return
	}
	writeJSON(w, http.StatusOK, order)
}

func notFound(w http.ResponseWriter, r *http.Request) {
	writeError(w, http.StatusNotFound, "not found")
}

func newMux() *http.ServeMux {
	mux := http.NewServeMux()
	mux.HandleFunc("POST /orders", handleCreateOrder)
	mux.HandleFunc("GET /orders/{id}", handleGetOrder)
	mux.HandleFunc("/", notFound)
	return mux
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
	}
	addr := "localhost:" + port

	fmt.Printf("order-api listening on http://%s\n", addr)
	if err := http.ListenAndServe(addr, newMux()); err != nil {
		fmt.Println("server error:", err)
		os.Exit(1)
	}
}
