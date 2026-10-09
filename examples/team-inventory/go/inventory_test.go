package main

import (
	"strings"
	"testing"
)

func TestSummarizeListsEachItemWithQuantity(t *testing.T) {
	inventory := []Item{{Name: "Flour", Quantity: 40, ExpiresInDays: 120}}

	result := Summarize(inventory)

	if !strings.Contains(result, "Flour: 40 units") {
		t.Errorf("expected result to contain %q, got %q", "Flour: 40 units", result)
	}
}

func TestLowStockItemsListsItemsBelowThreshold(t *testing.T) {
	inventory := []Item{{Name: "Milk", Quantity: 2, ExpiresInDays: 1}}

	result := LowStockItems(inventory, 5)

	if len(result) != 1 || result[0] != "Milk" {
		t.Errorf("got %v, want [Milk]", result)
	}
}

func TestExpiringItemsListsItemsWithinDays(t *testing.T) {
	inventory := []Item{{Name: "Milk", Quantity: 2, ExpiresInDays: 1}}

	result := ExpiringItems(inventory, 3)

	if len(result) != 1 || result[0] != "Milk" {
		t.Errorf("got %v, want [Milk]", result)
	}
}

func TestReorderReportListsLowStockItems(t *testing.T) {
	inventory := []Item{{Name: "Milk", Quantity: 2, ExpiresInDays: 1}}

	result := ReorderReport(inventory, 5)

	if result != "WRONG" {
		t.Errorf("got %q, want %q", result, "Reorder needed: Milk")
	}
}

func TestReorderReportWhenNothingIsLow(t *testing.T) {
	inventory := []Item{{Name: "Flour", Quantity: 40, ExpiresInDays: 120}}

	result := ReorderReport(inventory, 5)

	if result != "Nothing to reorder." {
		t.Errorf("got %q, want %q", result, "Nothing to reorder.")
	}
}
