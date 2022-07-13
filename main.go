package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

func main() {
	fmt.Println("GoServer Started")

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("new request")

		b, _ := io.ReadAll(r.Body)
		defer r.Body.Close()

		w.WriteHeader(200)
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]interface{}{
			"body":    string(b),
			"headers": map[string][]string(r.Header),
			"url":     r.URL.String(),
		})
	})

	http.ListenAndServe(":8081", nil)
}
