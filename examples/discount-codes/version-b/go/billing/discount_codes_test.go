package billing

import "testing"

func TestSave10ReturnsTenPercent(t *testing.T) {
	got, err := ApplyDiscountCode(100.0, "SAVE10")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if got != 10.0 {
		t.Errorf("got %.2f, want %.2f", got, 10.0)
	}
}

func TestSave5ReturnsFlatFive(t *testing.T) {
	got, err := ApplyDiscountCode(100.0, "SAVE5")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if got != 5.0 {
		t.Errorf("got %.2f, want %.2f", got, 5.0)
	}
}

func TestApplyDiscountCodeUnknownCodeReturnsError(t *testing.T) {
	_, err := ApplyDiscountCode(100.0, "BOGUS")
	if err == nil {
		t.Error("expected an error for an unknown discount code, got nil")
	}
}
