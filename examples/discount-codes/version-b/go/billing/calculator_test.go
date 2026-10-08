package billing

import "testing"

var smallOrder = []Item{
	{Name: "Burger", Price: 12.50, Qty: 2},
	{Name: "Fries", Price: 4.00, Qty: 2},
	{Name: "Soda", Price: 2.50, Qty: 2},
}

var largeOrder = []Item{
	{Name: "Steak", Price: 30.00, Qty: 2},
}

func TestNoDiscountCodeMatchesBaseline(t *testing.T) {
	bill, err := CalculateBill(smallOrder, 0.15, "")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if bill.Total != 46.74 {
		t.Errorf("got %.2f, want %.2f", bill.Total, 46.74)
	}
}

func TestSave10AppliesAfterLoyaltyDiscount(t *testing.T) {
	bill, err := CalculateBill(largeOrder, 0.15, "SAVE10")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if bill.Discount != 11.4 {
		t.Errorf("discount: got %.2f, want %.2f", bill.Discount, 11.4)
	}
	if bill.Tax != 3.89 {
		t.Errorf("tax: got %.2f, want %.2f", bill.Tax, 3.89)
	}
}

func TestSave5AppliesFlatAmount(t *testing.T) {
	bill, err := CalculateBill(smallOrder, 0.15, "SAVE5")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if bill.Discount != 5.0 {
		t.Errorf("discount: got %.2f, want %.2f", bill.Discount, 5.0)
	}
	if bill.Total != 40.59 {
		t.Errorf("total: got %.2f, want %.2f", bill.Total, 40.59)
	}
}

func TestCalculateBillUnknownCodeReturnsError(t *testing.T) {
	_, err := CalculateBill(smallOrder, 0.15, "BOGUS")
	if err == nil {
		t.Error("expected an error for an unknown discount code, got nil")
	}
}
