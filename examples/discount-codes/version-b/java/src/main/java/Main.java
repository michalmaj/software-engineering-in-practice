import billing.Calculator;

import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<Calculator.Item> items = List.of(
                new Calculator.Item("Burger", 12.50, 2),
                new Calculator.Item("Fries", 4.00, 2),
                new Calculator.Item("Soda", 2.50, 2));

        Calculator.Bill bill = Calculator.calculateBill(items, 0.15, "SAVE10");

        System.out.println("Receipt");
        System.out.println("-------");
        for (Calculator.Item item : items) {
            double lineTotal = item.price * item.qty;
            System.out.printf("%s: %d x $%.2f = $%.2f%n", item.name, item.qty, item.price, lineTotal);
        }
        System.out.printf("Subtotal: $%.2f%n", bill.subtotal);
        System.out.printf("Discount: -$%.2f%n", bill.discount);
        System.out.printf("Tax: $%.2f%n", bill.tax);
        System.out.printf("Tip: $%.2f%n", bill.tip);
        System.out.printf("Total: $%.2f%n", bill.total);
    }
}
