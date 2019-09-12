package main

import (
	"fmt"
	"github.com/PuerkitoBio/goquery"
	"log"
	"net/http"
	"os"
	"time"
)



func main() {
	start := time.Now()
	//Crawl("https://golang.org/", 4, fetcher)
	response, err := http.Get("https://au.jora.com")

	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	}
	defer response.Body.Close()
	if response.StatusCode != 200 {
		log.Fatalf("status code error: %d %s", response.StatusCode, response.Status)
	}

	doc, err := goquery.NewDocumentFromReader(response.Body)
	if err != nil {
		log.Fatal(err)
	}


	fmt.Println(doc.Attr("id"))
	end := time.Now()

	fmt.Println("Звакончили за ",  end.Sub(start))
} // fakeFetcher is Fetcher that returns canned results.

