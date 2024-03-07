import Foundation
import DequeModule

struct TaskModel: Identifiable, Hashable {
    let id: UUID
    let creation: Date
    let title: String
    let ofTaskList: UUID
    let isDone: Bool
    let details: String
    let priority: Int
    let date: Date?
    
    init(
        id: UUID = UUID(),
        creation: Date = Date(),
        title: String,
        ofTaskList: UUID = UUID(),
        isDone: Bool = false,
        details: String = "",
        priority: Int = 3,
        date: Date? = nil
    ) {
        self.id = id
        self.creation = creation
        self.title = title
        self.ofTaskList = ofTaskList
        self.isDone = isDone
        self.details = details
        self.priority = priority
        self.date = date
    }
    
    func edit(title: String? = nil, ofTaskList: UUID? = nil, isDone: Bool? = nil, details: String? = nil, priority: Int? = nil, date: Date? = nil) -> TaskModel {
        return TaskModel(id: self.id,
                         title: title ?? self.title,
                         ofTaskList: ofTaskList ?? self.ofTaskList,
                         isDone: isDone ?? self.isDone,
                         details: details ?? self.details,
                         priority: priority ?? self.priority,
                         date: date ?? self.date)
    }
    
    func toggleDone() -> TaskModel {
        return edit(isDone: !self.isDone)
    }
    
    
}

extension TaskModel: Equatable {
    static func == (lhs: TaskModel, rhs: TaskModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.ofTaskList == rhs.ofTaskList &&
        lhs.isDone == rhs.isDone &&
        lhs.details == rhs.details &&
        lhs.date?.string() == rhs.date?.string()
    }
}
