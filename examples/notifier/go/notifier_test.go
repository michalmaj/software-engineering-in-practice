package notifier

import (
	"reflect"
	"testing"
)

func TestSendReceiptReadyNotifiesWithOrderID(t *testing.T) {
	notifier := &InMemoryNotifier{}

	SendReceiptReady(notifier, "A123")

	want := []string{"Order A123 is ready."}
	if !reflect.DeepEqual(notifier.SentMessages, want) {
		t.Errorf("got %v, want %v", notifier.SentMessages, want)
	}
}
