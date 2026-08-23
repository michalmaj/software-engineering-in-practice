package main

import "testing"

func TestGreetingReturnsExpectedMessage(t *testing.T) {
	want := "Hello from the capstone starter!"
	if got := greeting(); got != want {
		t.Errorf("got %q, want %q", got, want)
	}
}
