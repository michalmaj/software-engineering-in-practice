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

func Summarize(inventory []Item) string {
	lines := []string{"Inventory Summary", "-----------------"}
	for _, item := range inventory {
		lines = append(lines, fmt.Sprintf("%s: %d units", item.Name, item.Quantity))
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
