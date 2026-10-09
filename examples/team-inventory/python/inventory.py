def low_stock_items(inventory: list[dict], threshold: int = 5) -> list[str]:
    return [item["name"] for item in inventory if item["quantity"] < threshold]


def summarize(inventory: list[dict]) -> str:
    lines = ["Inventory Summary", "-----------------"]
    for item in inventory:
        lines.append(f"{item['name']}: {item['quantity']} units")
    low_stock = low_stock_items(inventory)
    if low_stock:
        lines.append(f"Low stock: {', '.join(low_stock)}")
    return "\n".join(lines)


if __name__ == "__main__":
    sample_inventory = [
        {"name": "Tomatoes", "quantity": 3, "expires_in_days": 2},
        {"name": "Flour", "quantity": 40, "expires_in_days": 120},
        {"name": "Milk", "quantity": 2, "expires_in_days": 1},
    ]
    print(summarize(sample_inventory))
