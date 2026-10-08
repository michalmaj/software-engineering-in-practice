import java.util.List;

public class Main {

    static class Item {
        String name;
        double price;
        int qty;

        Item(String name, double price, int qty) {
            this.name = name;
            this.price = price;
            this.qty = qty;
        }
    }

    public static void main(String[] args) {
        List<Item> items = List.of(
                new Item("Burger", 12.50, 2),
                new Item("Fries", 4.00, 2),
                new Item("Soda", 2.50, 2));
        double tipRate = 0.15;

        double subtotal = 0;
        for (Item item : items) {
            subtotal += item.price * item.qty;
        }

        double discount = 0;
        if (subtotal >= 50) {
            discount = subtotal * 0.10;
        }

        double tax = subtotal * 0.08;

        double tip = (subtotal - discount) * tipRate;

        double total = subtotal - discount + tax + tip;

        System.out.println("Receipt");
        System.out.println("-------");
        for (Item item : items) {
            double lineTotal = item.price * item.qty;
            System.out.printf("%s: %d x $%.2f = $%.2f%n", item.name, item.qty, item.price, lineTotal);
        }
        System.out.printf("Subtotal: $%.2f%n", subtotal);
        System.out.printf("Discount: -$%.2f%n", discount);
        System.out.printf("Tax: $%.2f%n", tax);
        System.out.printf("Tip: $%.2f%n", tip);
        System.out.printf("Total: $%.2f%n", total);
    }
}
