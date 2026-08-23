from main import greeting


def test_greeting_returns_expected_message():
    assert greeting() == "Hello from the capstone starter!"
