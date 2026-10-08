package main

import "testing"

func TestGreetingReturnsExpectedMessage(t *testing.T) {
	want := "It works on my machine!"
	if got := greeting(); got != want {
		t.Errorf("got %q, want %q", got, want)
	}
}
