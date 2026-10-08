import pytest

from billing.calculator import calculate_bill

SMALL_ORDER = [("Burger", 12.50, 2), ("Fries", 4.00, 2), ("Soda", 2.50, 2)]  # subtotal 38
LARGE_ORDER = [("Steak", 30.00, 2)]  # subtotal 60, loyalty discount applies


def test_no_discount_code_matches_baseline():
    bill = calculate_bill(SMALL_ORDER, 0.15)

    assert bill["total"] == 46.74


def test_save10_applies_after_loyalty_discount():
    bill = calculate_bill(LARGE_ORDER, 0.15, discount_code="SAVE10")

    assert bill["discount"] == 11.4
    assert bill["tax"] == 3.89


def test_save5_applies_flat_amount():
    bill = calculate_bill(SMALL_ORDER, 0.15, discount_code="SAVE5")

    assert bill["discount"] == 5.0
    assert bill["total"] == 40.59


def test_unknown_code_raises_value_error():
    with pytest.raises(ValueError):
        calculate_bill(SMALL_ORDER, 0.15, discount_code="BOGUS")
