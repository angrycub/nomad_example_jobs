#!/bin/bash

echo "Building dnstest binaries..."

echo "- Linux AMD64"
mkdir -p out/linux_amd64/
GOOS=linux GOARCH=amd64 go build -o out/linux_amd64/dnstest main.go

echo "- Darwin AMD64"
mkdir -p out/darwin_amd64/
GOOS=darwin GOARCH=amd64 go build -o out/darwin_amd64/dnstest main.go

echo "- Windows AMD64"
mkdir -p out/windows_amd64/
GOOS=windows GOARCH=amd64 go build -o out/windows_amd64/dnstest.exe main.go

echo "- Linux ARM64"
mkdir -p out/linux_arm64/
GOOS=linux GOARCH=arm64 go build -o out/linux_arm64/dnstest main.go
