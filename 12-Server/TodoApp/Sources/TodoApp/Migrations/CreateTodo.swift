import Fluent

struct CreateTodo: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("todos")
            .id()
            .field("title", .string, .required)
            .field("is_complete", .bool, .required)
            .field("created_at", .datetime, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("todos").delete()
    }
}
