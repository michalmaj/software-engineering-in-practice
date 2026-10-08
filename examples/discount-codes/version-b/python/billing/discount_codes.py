DISCOUNT_CODES = {
    "SAVE10": lambda amount: amount * 0.10,
    "SAVE5": lambda amount: 5.0,
}


def apply_discount_code(amount: float, code: str) -> float:
    try:
        discount_fn = DISCOUNT_CODES[code]
    except KeyError:
        raise ValueError(f"unknown discount code: {code}") from None
    return discount_fn(amount)
