import Vapor
import Leaf
import Fluent
import FluentSQLiteDriver

func index(request: Request) async throws -> View {
    struct Context : Encodable {
        var books: [Book]
    }

    let books = (try? await Book.query(on: request.db).all()) ?? []
    return try await request.view.render("index", Context(books: books))
}

@main
public class BookList {
    public static func main() throws {
        let app = Application()

        app.views.use(.leaf)
        app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
        app.databases.use(.sqlite(.file("books.db")), as: .sqlite)

        app.migrations.add(CreateBooks())
        try app.group("api") { api in 
            try api.register(collection: BookController())
        }

        app.get(use: index)

        try app.run()
        app.shutdown()
    }
}
