from billing.calculator import calculate_bill

ITEMS = [
    ("Burger", 12.50, 2),
    ("Fries", 4.00, 2),
    ("Soda", 2.50, 2),
]
TIP_RATE = 0.15


def main() -> None:
    bill = calculate_bill(ITEMS, TIP_RATE, discount_code="SAVE10")
    print("Receipt")
    print("-------")
    for name, price, quantity in ITEMS:
        print(f"{name}: {quantity} x ${price:.2f} = ${price * quantity:.2f}")
    print(f"Subtotal: ${bill['subtotal']:.2f}")
    print(f"Discount: -${bill['discount']:.2f}")
    print(f"Tax: ${bill['tax']:.2f}")
    print(f"Tip: ${bill['tip']:.2f}")
    print(f"Total: ${bill['total']:.2f}")


if __name__ == "__main__":
    main()
