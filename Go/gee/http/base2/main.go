package main

import (
	"fmt"
	"log"
	"net/http"
)

// Engine ...定义了一个空结构体 Engine，来实现方法 ServeHTTP
type Engine struct{}

// 可以自由定义路由映射的规则，也可以统一添加一些处理逻辑等
func (engine *Engine) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	switch req.URL.Path {
	case "/":
		fmt.Fprintf(w, "URL.Path = %q\n", req.URL.Path)
	case "/hello":
		for k, v := range req.Header {
			fmt.Fprintf(w, "Header[%q] = %q\n", k, v)
		}
	default:
		fmt.Fprintf(w, "404 NOT FOUND: %s\n", req.URL)
	}
}

func main() {
	// 实现了 Engine 后，就可以拦截所有的 HTTP 请求，拥有了统一的控制入口
	engine := new(Engine)
	log.Fatal(http.ListenAndServe(":9999", engine))
}
