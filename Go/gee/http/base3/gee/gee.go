package gee

import (
	"fmt"
	"net/http"
)

// 定义类型 HandlerFunc，这是提供给框架使用者的，用来定义由映射的处理方法
type HandlerFunc func(http.ResponseWriter, *http.Request)

type Engine struct {
	// 在 Engine 中，添加了一张路由的映射表 router
	// key 是 string 类型，由请求方法和静态路由地址构成，如 GET | POST
	router map[string]HandlerFunc
}

func New() *Engine {
	return &Engine{router: make(map[string]HandlerFunc)}
}

func (engine *Engine) addRoute(method string, pattern string, handler HandlerFunc) {
	key := method + "-" + pattern
	engine.router[key] = handler
}

func (engine *Engine) GET(pattern string, handler HandlerFunc) {
	engine.addRoute("GET", pattern, handler)
}

func (engine *Engine) POST(pattern string, handler HandlerFunc) {
	engine.addRoute("POST", pattern, handler)
}

// 包装 ListenAndServe 方法
func (engine *Engine) Run(addr string) (err error) {
	return http.ListenAndServe(addr, engine)
}

// 解析请求的路径，查找路由映射表，如果查询到，就执行注册的处理方法，查不到就返回 NOT FOUND
func (engine *Engine) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	key := req.Method + "-" + req.URL.Path
	if handler, ok := engine.router[key]; ok {
		handler(w, req)
	} else {
		fmt.Fprintf(w, "404 NOT FOUND: %s\n", req.URL)
	}
}
