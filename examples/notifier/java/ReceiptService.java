public class ReceiptService {
    public static void sendReceiptReady(Notifier notifier, String orderId) {
        notifier.send("Order " + orderId + " is ready.");
    }
}
