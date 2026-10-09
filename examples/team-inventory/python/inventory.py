def low_stock_items(inventory: list[dict], threshold: int = 5) -> list[str]:
    return [item["name"] for item in inventory if item["quantity"] < threshold]


def expiring_items(inventory: list[dict], days: int = 3) -> list[str]:
    return [item["name"] for item in inventory if item["expires_in_days"] <= days]


def reorder_report(inventory: list[dict], threshold: int = 5) -> str:
    items = low_stock_items(inventory, threshold)
    if not items:
        return "Nothing to reorder."
    return f"Reorder needed: {', '.join(items)}"


def summarize(inventory: list[dict]) -> str:
    lines = ["Inventory Summary", "-----------------"]
    for item in inventory:
        lines.append(f"{item['name']}: {item['quantity']} units")
    low_stock = low_stock_items(inventory)
    if low_stock:
        lines.append(f"Low stock: {', '.join(low_stock)}")
    expiring = expiring_items(inventory)
    if expiring:
        lines.append(f"Expiring soon: {', '.join(expiring)}")
    return "\n".join(lines)


if __name__ == "__main__":
    sample_inventory = [
        {"name": "Tomatoes", "quantity": 3, "expires_in_days": 2},
        {"name": "Flour", "quantity": 40, "expires_in_days": 120},
        {"name": "Milk", "quantity": 2, "expires_in_days": 1},
    ]
    print(summarize(sample_inventory))
