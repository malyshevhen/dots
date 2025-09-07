package main

import "C"

//export AddGo
func AddGo(a C.int, b C.int) C.int {
	return a + b
}

func main() {}
