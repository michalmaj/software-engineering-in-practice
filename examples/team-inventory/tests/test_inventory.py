from inventory import summarize


def test_summarize_lists_each_item_with_quantity():
    inventory = [{"name": "Flour", "quantity": 40, "expires_in_days": 120}]

    result = summarize(inventory)

    assert "Flour: 40 units" in result
