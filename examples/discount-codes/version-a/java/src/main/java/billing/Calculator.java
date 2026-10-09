package billing;

import java.util.List;

/**
 * Discount-codes version A: discount-code recognition lives directly
 * inside calculateBill, coupled to the rest of the bill calculation.
 * See version B for the decoupled equivalent.
 */
public class Calculator {

    public static final double DISCOUNT_THRESHOLD = 50.0;
    public static final double LOYALTY_DISCOUNT_RATE = 0.10;
    public static final double TAX_RATE = 0.08;

    public static class Item {
        public final String name;
        public final double price;
        public final int qty;

        public Item(String name, double price, int qty) {
            this.name = name;
            this.price = price;
            this.qty = qty;
        }
    }

    public static class Bill {
        public final double subtotal;
        public final double discount;
        public final double tax;
        public final double tip;
        public final double total;

        public Bill(double subtotal, double discount, double tax, double tip, double total) {
            this.subtotal = subtotal;
            this.discount = discount;
            this.tax = tax;
            this.tip = tip;
            this.total = total;
        }
    }

    public static double calculateSubtotal(List<Item> items) {
        double subtotal = 0;
        for (Item item : items) {
            subtotal += item.price * item.qty;
        }
        return subtotal;
    }

    public static double calculateLoyaltyDiscount(double subtotal) {
        if (subtotal >= DISCOUNT_THRESHOLD) {
            return subtotal * LOYALTY_DISCOUNT_RATE;
        }
        return 0.0;
    }

    public static double calculateTax(double amount) {
        return amount * TAX_RATE;
    }

    public static double calculateTip(double amount, double tipRate) {
        return amount * tipRate;
    }

    private static double round2(double amount) {
        return Math.round(amount * 100) / 100.0;
    }

    /**
     * Computes a full bill. discountCode is the code to apply, or null
     * for no code. An unrecognized code throws
     * IllegalArgumentException — this is the coupled version, so that
     * recognition happens right here, next to subtotal/tax/tip
     * arithmetic that has nothing to do with discount codes.
     */
    public static Bill calculateBill(List<Item> items, double tipRate, String discountCode) {
        double subtotal = calculateSubtotal(items);
        double loyaltyDiscount = calculateLoyaltyDiscount(subtotal);
        double afterLoyalty = subtotal - loyaltyDiscount;

        double codeDiscount = 0.0;
        if (discountCode != null) {
            switch (discountCode) {
                case "SAVE10":
                    codeDiscount = afterLoyalty * 0.10;
                    break;
                case "SAVE5":
                    codeDiscount = 5.0;
                    break;
                default:
                    throw new IllegalArgumentException("unknown discount code: " + discountCode);
            }
        }

        double discount = loyaltyDiscount + codeDiscount;
        double tax = calculateTax(subtotal - discount);
        double tip = calculateTip(subtotal - discount, tipRate);
        double total = subtotal - discount + tax + tip;

        return new Bill(round2(subtotal), round2(discount), round2(tax), round2(tip), round2(total));
    }
}
