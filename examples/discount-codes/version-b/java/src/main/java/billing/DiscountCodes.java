package billing;

import java.util.Map;
import java.util.function.DoubleUnaryOperator;

/**
 * Maps each known discount code to the function that computes its
 * discount from the amount remaining after the loyalty discount.
 * Adding a code means adding one entry here — nothing in
 * Calculator.java changes. A functional interface (DoubleUnaryOperator,
 * from the standard library) is enough here; this doesn't need a
 * hand-rolled Strategy class hierarchy.
 */
public class DiscountCodes {

    private static final Map<String, DoubleUnaryOperator> CODES =
            Map.of(
                    "SAVE10", amount -> amount * 0.10,
                    "SAVE5", amount -> 5.0);

    public static double apply(double amount, String code) {
        DoubleUnaryOperator fn = CODES.get(code);
        if (fn == null) {
            throw new IllegalArgumentException("unknown discount code: " + code);
        }
        return fn.applyAsDouble(amount);
    }
}
