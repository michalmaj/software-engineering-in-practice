from inventory import expiring_items, summarize


def test_summarize_lists_each_item_with_quantity():
    inventory = [{"name": "Flour", "quantity": 40, "expires_in_days": 120}]

    result = summarize(inventory)

    assert "Flour: 40 units" in result


def test_expiring_items_lists_items_within_days():
    inventory = [{"name": "Milk", "quantity": 2, "expires_in_days": 1}]

    result = expiring_items(inventory)

    assert result == ["Milk"]
