import Fluent
import Vapor

// Leaf 템플릿에 전달할 데이터를 담는 구조체 (Encodable 준수)
struct TodosContext: Encodable {
    let title: String
    let todos: [TodoDTO] // Todo 모델 배열을 직접 포함
}

// TodoDTO는 Todo 모델을 Leaf 템플릿에 전달하기 위한 데이터 전송 객체
struct TodoDetailContext: Encodable {
    let title: String
    let todo: TodoDTO // Todo 모델을 Leaf 템플릿에 전달하기 위한 데이터 전송 객체
}

struct TodoController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let todos = routes.grouped("todos")

        todos.get(use: list)
        todos.get("new", use: showCreatePage) // GET /create - 생성 페이지 보여주기
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
        let title = "Todo 목록"
        let context: TodosContext = TodosContext(title: title, todos: todos.map { $0.toDTO() })
        return try await req.view.render("todos", context)
    }

    @Sendable
    func showCreatePage(req: Request) async throws -> View {
        return try await req.view.render("new", ["title": "새 Todo 추가"])
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
    func get(req: Request) async throws -> View {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let context: TodoDetailContext = TodoDetailContext(
            title: "Todo 상세보기", todo: todo.toDTO())
        return try await req.view.render("get", context)
    }

    // PUT /todos/:id - 특정 Todo 항목 수정 (API 유지)
    @Sendable
    func update(req: Request) async throws -> Response {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedTodo = try req.content.decode(Todo.self)
        todo.title = updatedTodo.title
        todo.isComplete = updatedTodo.isComplete
        try await todo.update(on: req.db)
        return req.redirect(to: "/todos/\(todo.id!)")
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
