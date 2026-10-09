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

    public static String summarize(List<Item> inventory) {
        List<String> lines = new ArrayList<>(List.of("Inventory Summary", "-----------------"));
        for (Item item : inventory) {
            lines.add(item.name + ": " + item.quantity + " units");
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
