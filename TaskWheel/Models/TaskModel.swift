import Foundation
import DequeModule

struct TaskModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let ofTaskList: UUID
    let isDone: Bool
    let details: String
    let date: Date?
    let priority: Int
    
    init(
        id: UUID = UUID(),
        title: String,
        ofTaskList: UUID = UUID(),
        isComplete: Bool = false,
        details: String = "",
        priority: Int = 3,
        date: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.ofTaskList = ofTaskList
        self.isDone = isComplete
        self.details = details
        self.priority = priority
        self.date = date
    }
    
    func edit(title: String? = nil, ofTaskList: UUID? = nil, isComplete: Bool? = nil, details: String? = nil, priority: Int? = nil, date: Date? = nil) -> TaskModel {
        return TaskModel(id: self.id,
                         title: title ?? self.title,
                         ofTaskList: ofTaskList ?? self.ofTaskList,
                         isComplete: isComplete ?? self.isDone,
                         details: details ?? self.details,
                         priority: priority ?? self.priority,
                         date: date ?? self.date)
    }
    
    func toggleDone() -> TaskModel {
        return edit(isComplete: !self.isDone)
    }
    
    
}

extension TaskModel {
    
    static func examples(ofTaskList: UUID) -> Deque<TaskModel> {
        [
            .init(title: "laundry", ofTaskList: ofTaskList, isComplete: true),
            .init(title: "dishes", ofTaskList: ofTaskList, isComplete: false),
            .init(title: "vacuum", ofTaskList: ofTaskList, isComplete: true, priority: 1),
            .init(title: "mop", ofTaskList: ofTaskList, isComplete: false, details: "where are the clean mop heads?", priority: 2),
            .init(title: "water plants", ofTaskList: ofTaskList, isComplete: false),
            .init(title: "throw out trash", ofTaskList: ofTaskList, isComplete: false, priority: 1),
            .init(title: "recycle plastic and paper, separate vinyl labels", ofTaskList: ofTaskList, isComplete: false),
            .init(title: "wipe countertop", ofTaskList: ofTaskList, isComplete: false),
            .init(title: "fold laundry", ofTaskList: ofTaskList, isComplete: false),
            .init(title: "clean bathroom", ofTaskList: ofTaskList, isComplete: true, priority: 2),
            .init(title: "organize shelf", ofTaskList: ofTaskList, isComplete: false, priority: 3)
        ]
    }
}
