import com.google.gson.annotations.SerializedName;

import java.util.List;

public class Order {
    @SerializedName("order_id")
    public final String orderId;

    public final List<Object> items;
    public final String status;

    public Order(String orderId, List<Object> items, String status) {
        this.orderId = orderId;
        this.items = items;
        this.status = status;
    }
}
