package billing;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.Test;

class DiscountCodesTest {

    @Test
    void save10ReturnsTenPercent() {
        assertEquals(10.0, DiscountCodes.apply(100.0, "SAVE10"));
    }

    @Test
    void save5ReturnsFlatFive() {
        assertEquals(5.0, DiscountCodes.apply(100.0, "SAVE5"));
    }

    @Test
    void unknownCodeThrows() {
        assertThrows(IllegalArgumentException.class, () -> DiscountCodes.apply(100.0, "BOGUS"));
    }
}
