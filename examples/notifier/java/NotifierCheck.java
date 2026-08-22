import java.util.List;

public class NotifierCheck {
    public static void main(String[] args) {
        InMemoryNotifier notifier = new InMemoryNotifier();

        ReceiptService.sendReceiptReady(notifier, "A123");

        List<String> expected = List.of("Order A123 is ready.");
        if (!notifier.getSentMessages().equals(expected)) {
            throw new AssertionError(
                "expected " + expected + " but got " + notifier.getSentMessages()
            );
        }

        System.out.println("All checks passed");
    }
}
