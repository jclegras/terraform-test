package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func healthcheck(w http.ResponseWriter, r *http.Request) {
	probeHeader := r.Header.Get("X-Probe")
	if probeHeader == "1234-test" {
		w.WriteHeader(http.StatusOK)
		fmt.Fprint(w, "OK\n")
	} else {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprint(w, "KO\n")
	}
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, os.ExpandEnv("${GREETING_MSG}\n"))
}

func main() {
	http.HandleFunc("/", handler)
	http.HandleFunc("/healthcheck", healthcheck)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
