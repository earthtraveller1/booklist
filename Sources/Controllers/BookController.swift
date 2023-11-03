import Fluent
import Vapor

struct BookController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("books") { books in 
            books.post(use: addBook)
            books.group(":id") { booksID in 
                booksID.delete(use: deleteBook)
                booksID.get("edit", use: getEditBookForm)
            }
        }
    }

    func getEditBookForm(request: Request) async throws -> View {
        if let bookID = request.parameters.get("id") {
            if let bookID = UUID.init(uuidString: bookID) {
                let book = try await Book
                    .query(on: request.db)
                    .filter(\.$id == bookID)
                    .first()

                return try await request.view.render("book-form", BookFormContext(book: book))
            }
        }

        throw Abort(.badRequest)
    }

    func addBook(request: Request) async throws -> View {
        let book = try request.content.decode(Book.self)
        try await book.create(on: request.db)

        struct Context : Encodable {
            var books: [Book]
        }
        let context = Context(books: try await Book.query(on: request.db).all())
        return try await request.view.render("main-items", context)
    }

    func deleteBook(request: Request) async throws -> HTTPStatus {
        if let bookID = request.parameters.get("id") {
            if let bookID = UUID.init(uuidString: bookID) {
            try await Book
                .query(on: request.db)
                .filter(\.$id == bookID)
                .delete()

                return .ok
            }
        } 

        return .badRequest
    }
}
