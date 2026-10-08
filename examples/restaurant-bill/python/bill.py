def main():
    items = [
        ("Burger", 12.50, 2),
        ("Fries", 4.00, 2),
        ("Soda", 2.50, 2),
    ]
    tip_rate = 0.15

    subtotal = 0
    for name, price, qty in items:
        subtotal += price * qty

    discount = 0
    if subtotal >= 50:
        discount = subtotal * 0.10

    tax = subtotal * 0.08

    tip = (subtotal - discount) * tip_rate

    total = round(subtotal - discount + tax + tip, 2)

    print("Receipt")
    print("-------")
    for name, price, qty in items:
        print(f"{name}: {qty} x ${price:.2f} = ${price * qty:.2f}")
    print(f"Subtotal: ${subtotal:.2f}")
    print(f"Discount: -${discount:.2f}")
    print(f"Tax: ${tax:.2f}")
    print(f"Tip: ${tip:.2f}")
    print(f"Total: ${total:.2f}")


if __name__ == "__main__":
    main()
