import java.util.ArrayList;
import java.util.List;

public class Inventory {

    public static class Item {
        public final String name;
        public final int quantity;
        public final int expiresInDays;

        public Item(String name, int quantity, int expiresInDays) {
            this.name = name;
            this.quantity = quantity;
            this.expiresInDays = expiresInDays;
        }
    }

    public static List<String> lowStockItems(List<Item> inventory, int threshold) {
        List<String> names = new ArrayList<>();
        for (Item item : inventory) {
            if (item.quantity < threshold) {
                names.add(item.name);
            }
        }
        return names;
    }

    public static List<String> expiringItems(List<Item> inventory, int days) {
        List<String> names = new ArrayList<>();
        for (Item item : inventory) {
            if (item.expiresInDays <= days) {
                names.add(item.name);
            }
        }
        return names;
    }

    public static String reorderReport(List<Item> inventory, int threshold) {
        List<String> items = lowStockItems(inventory, threshold);
        if (items.isEmpty()) {
            return "Nothing to reorder.";
        }
        return "Reorder needed: " + String.join(", ", items);
    }

    public static String summarize(List<Item> inventory) {
        List<String> lines = new ArrayList<>(List.of("Inventory Summary", "-----------------"));
        for (Item item : inventory) {
            lines.add(item.name + ": " + item.quantity + " units");
        }
        List<String> lowStock = lowStockItems(inventory, 5);
        if (!lowStock.isEmpty()) {
            lines.add("Low stock: " + String.join(", ", lowStock));
        }
        List<String> expiring = expiringItems(inventory, 3);
        if (!expiring.isEmpty()) {
            lines.add("Expiring soon: " + String.join(", ", expiring));
        }
        return String.join("\n", lines);
    }

    public static void main(String[] args) {
        List<Item> sampleInventory = List.of(
                new Item("Tomatoes", 3, 2),
                new Item("Flour", 40, 120),
                new Item("Milk", 2, 1));
        System.out.println(summarize(sampleInventory));
    }
}
