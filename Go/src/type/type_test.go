package type_test

import "testing"

type MyInt int64

/**
1. 不支持任何类型的隐式转换，并且非常严苛地不支持别名到原类型的隐式转换
2. 可以支持指针类型，但指针不支持任何运算
3. 字符串是值类型，默认初始化0值是0字符串，而不是为空
 */

func TestImplicit(t *testing.T) {
	var a int32 = 1
	var b int64
	// 不支持隐式类型转换
	b = int64(a)
	var c MyInt
	c = MyInt(b)
	t.Log(a, b, c)
}

/**
测试指针
*/
func TestPoint(t *testing.T) {
	a := 1
	aPtr := &a
	// 不支持指针运算
	// aPtr = aPtr + 1
	t.Log(a, aPtr)
	t.Logf("%T %T", a, aPtr)
}

func TestString(t *testing.T) {
	// 默认string为空字符串
	var s string
	t.Log("*" + s + "*")
	t.Log(len(s))
}
