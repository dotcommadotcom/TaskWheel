import Foundation
import DequeModule

struct TaskModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let isComplete: Bool
    
    init(id: UUID = UUID(), title: String, isComplete: Bool = false) {
        self.id = id
        self.title = title
        self.isComplete = isComplete
    }
    
    func editTitle(_ newTitle: String) -> TaskModel {
        return TaskModel(id: self.id, title: newTitle, isComplete: self.isComplete)
    }
    
    func toggleComplete() -> TaskModel {
        return TaskModel(id: self.id, title: self.title, isComplete: !self.isComplete)
    }
}

extension TaskModel {
    static let examples: Deque<TaskModel> = [
        .init(title: "laundry", isComplete: true),
        .init(title: "dishes", isComplete: true),
        .init(title: "vacuum", isComplete: true),
        .init(title: "mop", isComplete: false),
        .init(title: "water plants", isComplete: false),
        .init(title: "throw out trash", isComplete: false),
        .init(title: "recycle", isComplete: false),
        .init(title: "wipe countertop", isComplete: false),
        .init(title: "fold laundry", isComplete: false),
        .init(title: "clean bathroom", isComplete: false),
        .init(title: "organize shelf", isComplete: false),
        .init(title: "wipe mirror", isComplete: false),
        .init(title: "wipe windowsill", isComplete: false),
        .init(title: "sanitize toilet brushes", isComplete: false),
        .init(title: "call water company", isComplete: false),
        .init(title: "pay bills", isComplete: false),
        .init(title: "switch out spring clothes", isComplete: false),
        .init(title: "wipe electronics", isComplete: false),
        .init(title: "charge all electronics", isComplete: false),
        .init(title: "refill coffee", isComplete: false),
        .init(title: "buy milk", isComplete: false),
        .init(title: "buy bananas", isComplete: false),
        .init(title: "dry clean", isComplete: false),
        .init(title: "clean washing machine", isComplete: false),
        .init(title: "empty vacuum cleaner", isComplete: false),
    ]
}
