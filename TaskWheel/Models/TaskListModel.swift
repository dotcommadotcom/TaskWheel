import Foundation
import DequeModule

struct TaskListModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    
    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
    
    func edit(title: String? = nil) -> TaskListModel {
        return TaskListModel(id: self.id,
                             title: title ?? self.title)
    }
}

extension TaskListModel {
    static let examples: Deque<TaskListModel> = [
        .init(title: "chores"),
        .init(title: "homework"),
        .init(title: "digital cleanse"),
        .init(title: "to buy"),
    ]
}
