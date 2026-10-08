package main

import (
	"fmt"

	"discount-codes-version-a/billing"
)

func main() {
	items := []billing.Item{
		{Name: "Burger", Price: 12.50, Qty: 2},
		{Name: "Fries", Price: 4.00, Qty: 2},
		{Name: "Soda", Price: 2.50, Qty: 2},
	}

	bill, err := billing.CalculateBill(items, 0.15, "SAVE10")
	if err != nil {
		fmt.Println("error:", err)
		return
	}

	fmt.Println("Receipt")
	fmt.Println("-------")
	for _, it := range items {
		lineTotal := it.Price * float64(it.Qty)
		fmt.Printf("%s: %d x $%.2f = $%.2f\n", it.Name, it.Qty, it.Price, lineTotal)
	}
	fmt.Printf("Subtotal: $%.2f\n", bill.Subtotal)
	fmt.Printf("Discount: -$%.2f\n", bill.Discount)
	fmt.Printf("Tax: $%.2f\n", bill.Tax)
	fmt.Printf("Tip: $%.2f\n", bill.Tip)
	fmt.Printf("Total: $%.2f\n", bill.Total)
}
