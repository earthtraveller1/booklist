import Fluent

struct CreateBooks: Fluent.AsyncMigration {
    func prepare(on database: Fluent.Database) async throws {
        try await database.schema("books")
            .id()
            .field("title", .string, .required)
            .field("author", .string, .required)
            .field("year_published", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("books").delete()
    }
}
