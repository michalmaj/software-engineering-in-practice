package billing;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.util.List;
import org.junit.jupiter.api.Test;

class CalculatorTest {

    private static final List<Calculator.Item> SMALL_ORDER = List.of(
            new Calculator.Item("Burger", 12.50, 2),
            new Calculator.Item("Fries", 4.00, 2),
            new Calculator.Item("Soda", 2.50, 2));

    private static final List<Calculator.Item> LARGE_ORDER =
            List.of(new Calculator.Item("Steak", 30.00, 2));

    @Test
    void noDiscountCodeMatchesBaseline() {
        Calculator.Bill bill = Calculator.calculateBill(SMALL_ORDER, 0.15, null);

        assertEquals(46.74, bill.total);
    }

    @Test
    void save10AppliesAfterLoyaltyDiscount() {
        Calculator.Bill bill = Calculator.calculateBill(LARGE_ORDER, 0.15, "SAVE10");

        assertEquals(11.4, bill.discount);
        assertEquals(3.89, bill.tax);
    }

    @Test
    void save5AppliesFlatAmount() {
        Calculator.Bill bill = Calculator.calculateBill(SMALL_ORDER, 0.15, "SAVE5");

        assertEquals(5.0, bill.discount);
        assertEquals(40.59, bill.total);
    }

    @Test
    void unknownCodeThrows() {
        assertThrows(
                IllegalArgumentException.class,
                () -> Calculator.calculateBill(SMALL_ORDER, 0.15, "BOGUS"));
    }
}
