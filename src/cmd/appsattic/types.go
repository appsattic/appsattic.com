package main

type Project struct {
	Title    string
	Apex     string
	Features []string
	ImageUrl string
}

var projects []Project = []Project{
	Project{
		Title: "Imagelicious",
		Apex:  "imagelicious.org",
	},
	Project{
		Title: "publish.li",
		Apex:  "publish.li",
	},
	Project{
		Title: "bcrypt.org",
		Apex:  "bcrypt.org",
	},
}
