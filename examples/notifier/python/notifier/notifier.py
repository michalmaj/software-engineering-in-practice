from typing import Protocol


class Notifier(Protocol):
    def send(self, message: str) -> None: ...


class ConsoleNotifier:
    def send(self, message: str) -> None:
        print(f"sent: {message}")


class InMemoryNotifier:
    def __init__(self) -> None:
        self.sent_messages: list[str] = []

    def send(self, message: str) -> None:
        self.sent_messages.append(message)


def send_receipt_ready(notifier: Notifier, order_id: str) -> None:
    notifier.send(f"Order {order_id} is ready.")
