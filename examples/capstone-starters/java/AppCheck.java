public class AppCheck {
    public static void main(String[] args) {
        String expected = "Hello from the capstone starter!";
        String actual = App.greeting();
        if (!actual.equals(expected)) {
            throw new AssertionError("expected " + expected + " but got " + actual);
        }
        System.out.println("All checks passed");
    }
}
