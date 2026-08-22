package notifier

import "fmt"

type Notifier interface {
	Send(message string)
}

type ConsoleNotifier struct{}

func (c ConsoleNotifier) Send(message string) {
	fmt.Printf("sent: %s\n", message)
}

type InMemoryNotifier struct {
	SentMessages []string
}

func (n *InMemoryNotifier) Send(message string) {
	n.SentMessages = append(n.SentMessages, message)
}

func SendReceiptReady(n Notifier, orderID string) {
	n.Send(fmt.Sprintf("Order %s is ready.", orderID))
}
