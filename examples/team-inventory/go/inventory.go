package main

import (
	"fmt"
	"strings"
)

type Item struct {
	Name          string
	Quantity      int
	ExpiresInDays int
}

func LowStockItems(inventory []Item, threshold int) []string {
	var names []string
	for _, item := range inventory {
		if item.Quantity < threshold {
			names = append(names, item.Name)
		}
	}
	return names
}

func ExpiringItems(inventory []Item, days int) []string {
	var names []string
	for _, item := range inventory {
		if item.ExpiresInDays <= days {
			names = append(names, item.Name)
		}
	}
	return names
}

func Summarize(inventory []Item) string {
	lines := []string{"Inventory Summary", "-----------------"}
	for _, item := range inventory {
		lines = append(lines, fmt.Sprintf("%s: %d units", item.Name, item.Quantity))
	}
	lowStock := LowStockItems(inventory, 5)
	if len(lowStock) > 0 {
		lines = append(lines, fmt.Sprintf("Low stock: %s", strings.Join(lowStock, ", ")))
	}
	expiring := ExpiringItems(inventory, 3)
	if len(expiring) > 0 {
		lines = append(lines, fmt.Sprintf("Expiring soon: %s", strings.Join(expiring, ", ")))
	}
	return strings.Join(lines, "\n")
}

func main() {
	sampleInventory := []Item{
		{Name: "Tomatoes", Quantity: 3, ExpiresInDays: 2},
		{Name: "Flour", Quantity: 40, ExpiresInDays: 120},
		{Name: "Milk", Quantity: 2, ExpiresInDays: 1},
	}
	fmt.Println(Summarize(sampleInventory))
}
