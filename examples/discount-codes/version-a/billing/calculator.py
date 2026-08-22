DISCOUNT_THRESHOLD = 50.0
LOYALTY_DISCOUNT_RATE = 0.10
TAX_RATE = 0.08


def calculate_subtotal(items: list[tuple[str, float, int]]) -> float:
    return sum(price * quantity for _, price, quantity in items)


def calculate_loyalty_discount(subtotal: float) -> float:
    if subtotal >= DISCOUNT_THRESHOLD:
        return subtotal * LOYALTY_DISCOUNT_RATE
    return 0.0


def calculate_tax(amount: float) -> float:
    return amount * TAX_RATE


def calculate_tip(amount: float, tip_rate: float) -> float:
    return amount * tip_rate


def calculate_bill(
    items: list[tuple[str, float, int]],
    tip_rate: float,
    discount_code: str | None = None,
) -> dict[str, float]:
    subtotal = calculate_subtotal(items)
    loyalty_discount = calculate_loyalty_discount(subtotal)
    after_loyalty = subtotal - loyalty_discount

    code_discount = 0.0
    if discount_code is not None:
        if discount_code == "SAVE10":
            code_discount = after_loyalty * 0.10
        elif discount_code == "SAVE5":
            code_discount = 5.0
        else:
            raise ValueError(f"unknown discount code: {discount_code}")

    discount = loyalty_discount + code_discount
    tax = calculate_tax(subtotal - discount)
    tip = calculate_tip(subtotal - discount, tip_rate)
    total = round(subtotal - discount + tax + tip, 2)
    return {
        "subtotal": round(subtotal, 2),
        "discount": round(discount, 2),
        "tax": round(tax, 2),
        "tip": round(tip, 2),
        "total": total,
    }
