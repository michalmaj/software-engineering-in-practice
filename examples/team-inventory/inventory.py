def summarize(inventory: list[dict]) -> str:
    lines = ["Inventory Summary", "-----------------"]
    for item in inventory:
        lines.append(f"{item['name']}: {item['quantity']} units")
    return "\n".join(lines)


if __name__ == "__main__":
    sample_inventory = [
        {"name": "Tomatoes", "quantity": 3, "expires_in_days": 2},
        {"name": "Flour", "quantity": 40, "expires_in_days": 120},
        {"name": "Milk", "quantity": 2, "expires_in_days": 1},
    ]
    print(summarize(sample_inventory))
