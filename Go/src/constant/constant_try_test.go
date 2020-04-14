package constain_test

import "testing"

const (
	Monday = iota + 1
	Tuesday
	Wednesday
)

const (
	// 连续常量
	Readable = 1 << iota
	Writable
	Executable
)

func TestConstantTry(t *testing.T) {
	t.Log(Monday, Tuesday)
}

func TestConstantTry1(t *testing.T) {
	a := 7
	t.Log(a&Readable == Readable, a&Writable == Writable, a&Executable == Executable)
}
