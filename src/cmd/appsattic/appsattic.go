package main

import (
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"

	"github.com/gomiddleware/logger"
	"github.com/gomiddleware/logit"
	"github.com/gomiddleware/mux"
	"github.com/gomiddleware/slash"
)

func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func main() {
	// setup the logger
	lgr := logit.New(os.Stdout, "appsattic")

	// setup
	apex := os.Getenv("APPSATTIC_APEX")
	baseUrl := os.Getenv("APPSATTIC_BASE_URL")
	port := os.Getenv("APPSATTIC_PORT")
	if port == "" {
		log.Fatal("Specify a port to listen on in the environment variable 'APPSATTIC_PORT'")
	}

	// load up all templates
	tmpl, err := template.New("").ParseGlob("./templates/*.html")
	if err != nil {
		log.Fatal(err)
	}

	// the mux
	m := mux.New()

	m.Use("/", logger.NewLogger(lgr))

	// do some static routes before doing logging
	m.All("/s", fileServer("static"))
	m.Get("/favicon.ico", serveFile("./static/favicon.ico"))
	m.Get("/robots.txt", serveFile("./static/robots.txt"))

	m.Get("/sitemap.txt", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/plain")
		fmt.Fprintf(w, baseUrl+"/\n")
	})

	m.Get("/", func(w http.ResponseWriter, r *http.Request) {
		data := struct {
			Apex    string
			BaseUrl string
			Apps    map[string]App
		}{
			apex,
			baseUrl,
			apps,
		}
		render(w, tmpl, "index.html", data)
	})

	m.Get("/contact", func(w http.ResponseWriter, r *http.Request) {
		data := struct {
			Apex    string
			BaseUrl string
			Apps    map[string]App
		}{
			apex,
			baseUrl,
			apps,
		}
		render(w, tmpl, "contact.html", data)
	})

	// redirect the old project pages, to the new /app/ pages
	m.Get("/project/imagelicious/", redirect("/app/imagelicious.org/"))
	m.Get("/project/bcrypt/", redirect("/app/bcrypt.org/"))
	m.Get("/project/publish/", redirect("/app/publish.li/"))
	m.Get("/project", redirect("/app/"))
	m.Get("/project/", redirect("/app/"))

	m.Get("/app", redirect("/"))
	m.Get("/app/", redirect("/"))

	m.Get("/app/:appName", slash.Add)
	m.Get("/app/:appName/", func(w http.ResponseWriter, r *http.Request) {
		appName := mux.Vals(r)["appName"]
		app, ok := apps[appName]
		if !ok {
			notFound(w, r)
			return
		}

		data := struct {
			Apex    string
			BaseUrl string
			Apps    map[string]App
			App     App
		}{
			apex,
			baseUrl,
			apps,
			app,
		}
		render(w, tmpl, "app.html", data)
	})

	// finally, check all routing was added correctly
	check(m.Err)

	// server
	fmt.Printf("Starting server, listening on port %s\n", port)
	errServer := http.ListenAndServe(":"+port, m)
	check(errServer)
}
