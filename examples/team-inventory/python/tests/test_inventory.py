from inventory import low_stock_items, summarize


def test_summarize_lists_each_item_with_quantity():
    inventory = [{"name": "Flour", "quantity": 40, "expires_in_days": 120}]

    result = summarize(inventory)

    assert "Flour: 40 units" in result


def test_low_stock_items_lists_items_below_threshold():
    inventory = [{"name": "Milk", "quantity": 2, "expires_in_days": 1}]

    result = low_stock_items(inventory)

    assert result == ["Milk"]
