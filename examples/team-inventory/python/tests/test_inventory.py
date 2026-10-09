from inventory import expiring_items, low_stock_items, reorder_report, summarize


def test_summarize_lists_each_item_with_quantity():
    inventory = [{"name": "Flour", "quantity": 40, "expires_in_days": 120}]

    result = summarize(inventory)

    assert "Flour: 40 units" in result


def test_low_stock_items_lists_items_below_threshold():
    inventory = [{"name": "Milk", "quantity": 2, "expires_in_days": 1}]

    result = low_stock_items(inventory)

    assert result == ["Milk"]


def test_expiring_items_lists_items_within_days():
    inventory = [{"name": "Milk", "quantity": 2, "expires_in_days": 1}]

    result = expiring_items(inventory)

    assert result == ["Milk"]


def test_reorder_report_lists_low_stock_items():
    inventory = [{"name": "Milk", "quantity": 2, "expires_in_days": 1}]

    result = reorder_report(inventory)

    assert result == "WRONG"


def test_reorder_report_when_nothing_is_low():
    inventory = [{"name": "Flour", "quantity": 40, "expires_in_days": 120}]

    result = reorder_report(inventory)

    assert result == "Nothing to reorder."
