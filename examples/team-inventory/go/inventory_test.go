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
