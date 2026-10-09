import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;
import org.junit.jupiter.api.Test;

class InventoryTest {

    @Test
    void summarizeListsEachItemWithQuantity() {
        List<Inventory.Item> inventory = List.of(new Inventory.Item("Flour", 40, 120));

        String result = Inventory.summarize(inventory);

        assertTrue(result.contains("Flour: 40 units"));
    }

    @Test
    void lowStockItemsListsItemsBelowThreshold() {
        List<Inventory.Item> inventory = List.of(new Inventory.Item("Milk", 2, 1));

        List<String> result = Inventory.lowStockItems(inventory, 5);

        assertEquals(List.of("Milk"), result);
    }

    @Test
    void expiringItemsListsItemsWithinDays() {
        List<Inventory.Item> inventory = List.of(new Inventory.Item("Milk", 2, 1));

        List<String> result = Inventory.expiringItems(inventory, 3);

        assertEquals(List.of("Milk"), result);
    }

    @Test
    void reorderReportListsLowStockItems() {
        List<Inventory.Item> inventory = List.of(new Inventory.Item("Milk", 2, 1));

        String result = Inventory.reorderReport(inventory, 5);

        assertEquals("Reorder needed: Milk", result);
    }

    @Test
    void reorderReportWhenNothingIsLow() {
        List<Inventory.Item> inventory = List.of(new Inventory.Item("Flour", 40, 120));

        String result = Inventory.reorderReport(inventory, 5);

        assertEquals("Nothing to reorder.", result);
    }
}
