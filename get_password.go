package main

import (
    "fmt"
    // "flag"
    "golang.org/x/crypto/ssh/terminal"
	"log"
    "os"
    "syscall"
)

// options
var debug = false
var ask = true

func main() {
    // options:
    //  -debug
    //  -ask

    // debugPtr := flag.Bool("debug", false, "a bool")
    // askPtr := flag.Bool("ask", false, "a bool (set to true if 'sudo -A' begins the argument list and SUDO_ASKPATH is set to this program)")
    // flag.Parse()

    // debug = *debugPtr
    // ask = *askPtr

    argsWithoutProg := os.Args[1:]
    if argsWithoutProg[0] == "sudo" && argsWithoutProg[1] == "-A" {
        ask = true
    }
    pass := ""
    for len(pass) == 0 {
        if ! ask {
            fmt.Printf("Password: ")
        }
        bpass, err := terminal.ReadPassword(int(syscall.Stdin))
        if ! ask {
            fmt.Printf("\n")
        }
        if err != nil {
            log.Printf("Failed to get password, error is %s\n", err)
            log.Fatal(err)
        }
        pass = string(bpass)
        if debug {
            fmt.Printf("password length: %d\n", len(pass))
        }
        if ask {
            fmt.Printf("%s\n", pass)
        }
    }
    if ! ask {
        fmt.Printf("Password read\n")
    }
}
