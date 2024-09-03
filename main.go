package main

import (
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", getHello)
	err := http.ListenAndServe(":8080", nil)
	if errors.Is(err, http.ErrServerClosed) {
		fmt.Printf("server closed\n")
	} else if err != nil {
		fmt.Printf("error starting server: %s\n", err)
		os.Exit(1)
	}
}

func getHello(w http.ResponseWriter, r *http.Request) {
	name := r.URL.Query().Get("name")
	if name == "" {
		name = "stranger"
	}
	message := fmt.Sprintf(
		"<!DOCTYPE html><html><body>"+
		"<p>Hello <span style=\"font-size: large;\"><strong>Paphat Sitthisang</strong></span> %s</p>"+
		"</body></html>",
		name,
	)
	w.Header().Set("Content-Type", "text/html")
	io.WriteString(w, message)
}
