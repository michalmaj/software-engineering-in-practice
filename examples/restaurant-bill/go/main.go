package main

import "fmt"

type item struct {
	name  string
	price float64
	qty   int
}

func main() {
	items := []item{
		{"Burger", 12.50, 2},
		{"Fries", 4.00, 2},
		{"Soda", 2.50, 2},
	}
	tipRate := 0.15

	subtotal := 0.0
	for _, it := range items {
		subtotal += it.price * float64(it.qty)
	}

	discount := 0.0
	if subtotal >= 50 {
		discount = subtotal * 0.10
	}

	tax := subtotal * 0.08

	tip := (subtotal - discount) * tipRate

	total := subtotal - discount + tax + tip

	fmt.Println("Receipt")
	fmt.Println("-------")
	for _, it := range items {
		lineTotal := it.price * float64(it.qty)
		fmt.Printf("%s: %d x $%.2f = $%.2f\n", it.name, it.qty, it.price, lineTotal)
	}
	fmt.Printf("Subtotal: $%.2f\n", subtotal)
	fmt.Printf("Discount: -$%.2f\n", discount)
	fmt.Printf("Tax: $%.2f\n", tax)
	fmt.Printf("Tip: $%.2f\n", tip)
	fmt.Printf("Total: $%.2f\n", total)
}
