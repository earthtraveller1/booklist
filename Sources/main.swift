import Vapor
import Leaf
import Fluent
import FluentSQLiteDriver

struct BookFormContext : Encodable {
    // If book is nil, that means we are constructing a 
    // form for adding books. Otherwise, we are constructing
    // a form for editing an existing book.
    var book: Book? = nil
}

func index(request: Request) async throws -> View {
    struct Context : Encodable {
        var books: [Book]
    }

    let books = (try? await Book.query(on: request.db).all()) ?? []
    return try await request.view.render("index", Context(books: books))
}

func addBookForm(request: Request) async throws -> View {
    return try await request.view.render("book-form", BookFormContext())
}

let app = Application()

app.views.use(.leaf)
app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
app.databases.use(.sqlite(.file("books.db")), as: .sqlite)

app.migrations.add(CreateBooks())
try app.group("api") { api in 
    try api.register(collection: BookController())
    api.get("add-book-form", use: addBookForm)
}

app.get(use: index)

try app.run()
app.shutdown()
