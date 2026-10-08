import pytest

from billing.discount_codes import apply_discount_code


def test_save10_returns_ten_percent():
    assert apply_discount_code(100.0, "SAVE10") == 10.0


def test_save5_returns_flat_five():
    assert apply_discount_code(100.0, "SAVE5") == 5.0


def test_unknown_code_raises_value_error():
    with pytest.raises(ValueError):
        apply_discount_code(100.0, "BOGUS")
