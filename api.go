package main

import (
  "net/http"
  "fmt"
  "log"
  "os"
  "io/ioutil"
)

func main() {
  apikey := os.Getenv("OPENWEATHERMAP_API_KEY")
  if apikey == "" {
    log.Fatal("Empty openweathermap.com api key")
  }

  http.HandleFunc("/forecast", func(w http.ResponseWriter, r *http.Request) {
    enableCors(&w)
    url := fmt.Sprintf("https://api.openweathermap.org/data/2.5/forecast?q=London,uk&mode=json&units=metric&appid=%s", apikey)

    resp, err := http.Get(url)
    if err != nil {
      log.Print(err)
    }

    body, err := ioutil.ReadAll(resp.Body)
    fmt.Fprintln(w, string(body))
  })

  log.Fatal(http.ListenAndServe(":9000", nil))
}

func enableCors(w *http.ResponseWriter) {
  (*w).Header().Set("Access-Control-Allow-Origin", "*")
}
