package billing

import "fmt"

// discountCodes maps each known code to the function that computes its
// discount from the amount remaining after the loyalty discount.
// Adding a code means adding one entry here — nothing in calculator.go
// changes.
var discountCodes = map[string]func(amount float64) float64{
	"SAVE10": func(amount float64) float64 { return amount * 0.10 },
	"SAVE5":  func(amount float64) float64 { return 5.0 },
}

func ApplyDiscountCode(amount float64, code string) (float64, error) {
	fn, ok := discountCodes[code]
	if !ok {
		return 0, fmt.Errorf("unknown discount code: %s", code)
	}
	return fn(amount), nil
}
