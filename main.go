package main

import (
	"fmt"
	"gopkg.in/yaml.v2"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

const configFile = "/etc/pkgdaemonx/config.yml"
const defaultAddress = "127.0.0.1:1234"

var (
	Version string
	Build   string
)

type Config struct {
	Address string
	Secret  string
}

func main() {
	data, err := ioutil.ReadFile(configFile)
	if err != nil {
		log.Println(err)
		return
	}

	var config = &Config{}
	yaml.Unmarshal(data, &config)

	address := os.Getenv("PKG_X_ADDRESS")
	if len(address) == 0 {
		address = defaultAddress
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		message := "Hello, world, I'm running on: %s\nVersion: %s\nBuild: %s\nMy secret: %s"
		response := fmt.Sprintf(
			message,
			address,
			Version,
			Build,
			config.Secret,
		)
		w.Write([]byte(response))
	})
	http.ListenAndServe(address, nil)
}
