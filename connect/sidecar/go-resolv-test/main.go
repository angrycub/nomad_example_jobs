package main

import (
	"context"
	"flag"
	"fmt"
	"net"
	"os"

)

func main() {
    preferGo := flag.Bool("go", false, "use host resolution")
    // useGoReolve := flag.Bool("go", false, "a bool")
    flag.Parse()
	
	if len(flag.Args()) != 1 {
		fmt.Println("command takes one argument--hostname to resolve.");
		os.Exit(1);
	}

	hostname := flag.Args()[0]

	r := net.Resolver{
		PreferGo: *preferGo,
	}

	iprecords, err := r.LookupHost(context.Background(), hostname)

	if err != nil {
		fmt.Println(err);
		os.Exit(1);
	}

	if len(iprecords) == 0 {
		fmt.Println("No records found.");
	}

	for _, ip := range iprecords {
		fmt.Println(ip);
	}
}
