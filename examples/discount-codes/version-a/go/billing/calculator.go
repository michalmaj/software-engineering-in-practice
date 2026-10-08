// Package billing implements discount-codes version A: discount-code
// recognition lives directly inside CalculateBill, coupled to the rest
// of the bill calculation. See version B for the decoupled equivalent.
package billing

import (
	"fmt"
	"math"
)

const (
	DiscountThreshold   = 50.0
	LoyaltyDiscountRate = 0.10
	TaxRate             = 0.08
)

type Item struct {
	Name  string
	Price float64
	Qty   int
}

type Bill struct {
	Subtotal float64
	Discount float64
	Tax      float64
	Tip      float64
	Total    float64
}

func CalculateSubtotal(items []Item) float64 {
	subtotal := 0.0
	for _, it := range items {
		subtotal += it.Price * float64(it.Qty)
	}
	return subtotal
}

func CalculateLoyaltyDiscount(subtotal float64) float64 {
	if subtotal >= DiscountThreshold {
		return subtotal * LoyaltyDiscountRate
	}
	return 0.0
}

func CalculateTax(amount float64) float64 {
	return amount * TaxRate
}

func CalculateTip(amount, tipRate float64) float64 {
	return amount * tipRate
}

func round2(x float64) float64 {
	return math.Round(x*100) / 100
}

// CalculateBill computes a full bill. discountCode is the code to
// apply, or "" for no code. An unrecognized code returns an error —
// this is the coupled version, so that recognition happens right here,
// next to subtotal/tax/tip arithmetic that has nothing to do with
// discount codes.
func CalculateBill(items []Item, tipRate float64, discountCode string) (Bill, error) {
	subtotal := CalculateSubtotal(items)
	loyaltyDiscount := CalculateLoyaltyDiscount(subtotal)
	afterLoyalty := subtotal - loyaltyDiscount

	codeDiscount := 0.0
	if discountCode != "" {
		switch discountCode {
		case "SAVE10":
			codeDiscount = afterLoyalty * 0.10
		case "SAVE5":
			codeDiscount = 5.0
		default:
			return Bill{}, fmt.Errorf("unknown discount code: %s", discountCode)
		}
	}

	discount := loyaltyDiscount + codeDiscount
	tax := CalculateTax(subtotal - discount)
	tip := CalculateTip(subtotal-discount, tipRate)
	total := subtotal - discount + tax + tip

	return Bill{
		Subtotal: round2(subtotal),
		Discount: round2(discount),
		Tax:      round2(tax),
		Tip:      round2(tip),
		Total:    round2(total),
	}, nil
}
