import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        return "It works!"
    }

    try app.register(collection: TodoController())
}
