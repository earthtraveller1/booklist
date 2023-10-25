import Vapor
import Fluent

final class Book: Model, Encodable, Decodable {
    static let schema: String = "books"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "author")
    var author: String

    @Field(key: "year_published")
    var yearPublished: String

    init() {}

    init(id: UUID? = nil, title: String, author: String, yearPublished: String) {
        self.id = id
        self.title = title
        self.author = author
        self.yearPublished = yearPublished
    }
}
