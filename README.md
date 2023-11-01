# BookList

A simple web application for managing books, written in Swift. Meant to serve as an exercise in building CRUD apps in Swift.

## Quick Start

Assuming that you have at least Swift 5.9 installed.

First, you need to set up the databases to ensure that they exists first. You can do that with the built-in migration that I wrote.

```bash
swift run --configuration release booklist migrate
```

This has to be done only once. Afterwards, simply run

```bash
swift run --configuration release
```

To run the program, and visit `127.0.0.1:8080` in your browser to use the web application.
