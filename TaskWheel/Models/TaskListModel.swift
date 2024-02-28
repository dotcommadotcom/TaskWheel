import Foundation
import DequeModule

struct TaskListModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    
    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
}

extension TaskListModel {
    static let examples: Deque<TaskListModel> = [
        .init(title: "chores"),
        .init(title: "homework"),
        .init(title: "job search"),
        .init(title: "to buy"),
    ]
}
