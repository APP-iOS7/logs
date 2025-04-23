import Fluent
import Vapor

struct TodoDTO: Content {
    var id: UUID?
    var title: String?
    var isComplete: Bool?
    var createdAt: Date?
    
    func toModel() -> Todo {
        let model = Todo()
        
        model.id = self.id
        
        if let title = self.title {
            model.title = title
        }
        
        if let isComplete = self.isComplete {
            model.isComplete = isComplete
        }
        
        if let createdAt = self.createdAt {
            model.createdAt = createdAt
        }
        return model
    }
}
