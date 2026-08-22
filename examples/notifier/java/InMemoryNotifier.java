import java.util.ArrayList;
import java.util.List;

public class InMemoryNotifier implements Notifier {
    private final List<String> sentMessages = new ArrayList<>();

    @Override
    public void send(String message) {
        sentMessages.add(message);
    }

    public List<String> getSentMessages() {
        return sentMessages;
    }
}
