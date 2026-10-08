from main import greeting


def test_greeting_contains_the_message():
    assert "It works on my machine!" in greeting()
