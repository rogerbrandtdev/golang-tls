package main

import (
    "crypto/tls"
    "log"
    "os"
)

var hostname string

func main() {
    var main_hostname string
    argsWithoutProg := os.Args[1:]
    if len(argsWithoutProg) == 1 {
        main_hostname = argsWithoutProg[0]
    } else {
        main_hostname, _ = os.Hostname()
    }
    hostname = main_hostname
    log.SetFlags(log.Lshortfile)

    conf := &tls.Config{
         //InsecureSkipVerify: true,
    }
    conn, err := tls.Dial("tcp", hostname + ":443", conf)
    if err != nil {
        log.Println(err)
        return
    }
    defer conn.Close()

    n, err := conn.Write([]byte("hello\n"))
    if err != nil {
        log.Println(n, err)
        return
    }

    buf := make([]byte, 100)
    n, err = conn.Read(buf)
    if err != nil {
        log.Println(n, err)
        return
    }

    println(string(buf[:n]))
}
