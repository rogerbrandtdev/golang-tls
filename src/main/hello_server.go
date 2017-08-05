package main

import (
    // "fmt"
    // "io"
    "log"
    "net/http"
    "os"
)

var hostname string

func HelloServer(w http.ResponseWriter, req *http.Request) {
    w.Header().Set("Content-Type", "text/plain")
    w.Write([]byte("This is an example server.\n"))
    // fmt.Fprintf(w, "This is an example server.\n")
    // io.WriteString(w, "This is an example server.\n")
}

func main() {
    var main_hostname string
    argsWithoutProg := os.Args[1:]
    if len(argsWithoutProg) == 1 {
        main_hostname = argsWithoutProg[0]
    } else {
        main_hostname, _ = os.Hostname()
    }
    hostname = main_hostname
    http.HandleFunc("/hello", HelloServer)
    err := http.ListenAndServeTLS(hostname + ":443", "server.crt", "server.key", nil)
    if err != nil {
        log.Fatal("ListenAndServe: ", err)
    }
}
