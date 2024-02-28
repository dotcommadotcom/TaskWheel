import Foundation
import DequeModule

struct TaskModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let ofTaskList: UUID
    let isComplete: Bool
    let details: String
    let priority: Int
    
    init(id: UUID = UUID(), title: String, ofTaskList: UUID = UUID(), isComplete: Bool = false, details: String = "", priority: Int = 4) {
        self.id = id
        self.title = title
        self.ofTaskList = ofTaskList
        self.isComplete = isComplete
        self.details = details
        self.priority = priority
    }
    
    func edit(title: String? = nil, ofTaskList: UUID? = nil, isComplete: Bool? = nil, details: String? = nil, priority: Int? = nil) -> TaskModel {
        return TaskModel(id: self.id,
                         title: title ?? self.title,
                         ofTaskList: ofTaskList ?? self.ofTaskList,
                         isComplete: isComplete ?? self.isComplete,
                         details: details ?? self.details,
                         priority: priority ?? self.priority)
    }
    
    func toggleComplete() -> TaskModel {
        return edit(isComplete: !self.isComplete)
    }
}

extension TaskModel {
    static let examples: Deque<TaskModel> = [
        .init(title: "laundry", isComplete: true),
        .init(title: "dishes", isComplete: true),
        .init(title: "vacuum", isComplete: true, priority: 1),
        .init(title: "mop", isComplete: false, details: "where are the clean mop heads?"),
        .init(title: "water plants", isComplete: false),
        .init(title: "throw out trash", isComplete: false, priority: 1),
        .init(title: "recycle plastic and paper, separate vinyl labels", isComplete: false),
        .init(title: "wipe countertop", isComplete: false),
        .init(title: "fold laundry", isComplete: false),
        .init(title: "clean bathroom", isComplete: false, priority: 2),
        .init(title: "organize shelf", isComplete: false),
        .init(title: "wipe mirror", isComplete: false, priority: 3),
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
