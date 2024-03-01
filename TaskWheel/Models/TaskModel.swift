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
    
    static func examples(ofTaskList: UUID) -> Deque<TaskModel> {
        [
            .init(title: "laundry", ofTaskList: ofTaskList, isComplete: true),
            .init(title: "dishes", ofTaskList: ofTaskList, isComplete: true),
            .init(title: "vacuum", ofTaskList: ofTaskList, isComplete: true, priority: 1),
            .init(title: "mop", ofTaskList: ofTaskList, isComplete: false, details: "where are the clean mop heads?", priority: 2),
            .init(title: "water plants", ofTaskList: ofTaskList, isComplete: false),
            .init(title: "throw out trash", ofTaskList: ofTaskList, isComplete: false, priority: 1),
            .init(title: "recycle plastic and paper, separate vinyl labels", ofTaskList: ofTaskList, isComplete: false),
            .init(title: "wipe countertop", ofTaskList: ofTaskList, isComplete: false),
            .init(title: "fold laundry", ofTaskList: ofTaskList, isComplete: false),
            .init(title: "clean bathroom", ofTaskList: ofTaskList, isComplete: false, priority: 2),
            .init(title: "organize shelf", ofTaskList: ofTaskList, isComplete: false),
            .init(title: "wipe mirror", ofTaskList: ofTaskList, isComplete: false, priority: 3),
            .init(title: "wipe windowsill", ofTaskList: ofTaskList, isComplete: false),
            .init(title: "sanitize toilet brushes", ofTaskList: ofTaskList, isComplete: false),
            .init(title: "call water company", ofTaskList: ofTaskList, isComplete: false),
        ]
    }
}
