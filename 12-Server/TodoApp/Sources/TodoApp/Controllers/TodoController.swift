import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let todos = routes.grouped("todos")

        todos.get(use: list)
        todos.get("create", use: showCreatePage) // GET /create - 생성 페이지 보여주기
        todos.post(use: create)  // POST는 여전히 JSON API로 유지 (또는 필요 시 수정)
        todos.group(":todoID") { todo in
            // 개별 조회/수정/삭제도 필요 시 View 렌더링으로 변경 가능
            todo.get(use: get)
            todo.put(use: update)
            todo.delete(use: delete)
        }
    }

    @Sendable
    func list(req: Request) async throws -> View {
        let todos: [Todo] = try await Todo.query(on: req.db).all()
        let context = ["todos": todos.map { $0.toDTO() }]
        return try await req.view.render("todos", context)
    }

    @Sendable
    func showCreatePage(req: Request) async throws -> View {
        return try await req.view.render("create", ["title": "새 Todo 추가"])
    }

    // POST /todos - 새 Todo 항목 생성 (API 유지)
    @Sendable
    func create(req: Request) async throws -> Response {
        let todo: Todo = try req.content.decode(Todo.self)
        try await todo.save(on: req.db)
        return req.redirect(to: "/todos")
    }

    // GET /todos/:id - 특정 Todo 항목 조회 (API 유지)
    @Sendable
    func get(req: Request) async throws -> TodoDTO {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return todo.toDTO()
    }

    // PUT /todos/:id - 특정 Todo 항목 수정 (API 유지)
    @Sendable
    func update(req: Request) async throws -> TodoDTO {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedTodo = try req.content.decode(Todo.self)
        todo.title = updatedTodo.title
        todo.isComplete = updatedTodo.isComplete
        try await todo.update(on: req.db)
        return todo.toDTO()
    }

    // DELETE /todos/:id - 특정 Todo 항목 삭제 (API 유지)
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await todo.delete(on: req.db)
        return .noContent
    }
}
