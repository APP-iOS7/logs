import Foundation
import Fluent
import struct Foundation.UUID

/// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property
/// It is recommended you write your model with sendability checking on and then suppress the warning
/// afterwards with `@unchecked Sendable`.
final class Todo: Model, @unchecked Sendable {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "is_complete")
    var isComplete: Bool

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, title: String, isComplete: Bool = false, createdAt: Date? = Date()) {
        self.id = id
        self.title = title
    }
    
    func toDTO() -> TodoDTO {
        .init(
            id: self.id,
            title: self.$title.value,
            isComplete: self.$isComplete.value,
            createdAt: self.$createdAt.value as? Date ?? Date()
        )
    }
}
