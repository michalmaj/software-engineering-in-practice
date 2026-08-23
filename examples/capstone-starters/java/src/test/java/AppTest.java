import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class AppTest {
    @Test
    void greetingReturnsExpectedMessage() {
        assertEquals("Hello from the capstone starter!", App.greeting());
    }
}
