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
}
