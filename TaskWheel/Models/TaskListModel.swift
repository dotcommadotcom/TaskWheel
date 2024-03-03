import Foundation
import DequeModule

struct TaskListModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let isDoneVisible: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        isDoneVisible: Bool = true
    ) {
        self.id = id
        self.title = title
        self.isDoneVisible = isDoneVisible
    }
    
    func edit(title: String? = nil, isDoneVisible: Bool? = nil) -> TaskListModel {
        return TaskListModel(id: self.id,
                             title: title ?? self.title,
                             isDoneVisible: isDoneVisible ?? self.isDoneVisible)
    }
    
    func toggleDoneVisible()  -> TaskListModel {
        return edit(isDoneVisible: !self.isDoneVisible)
    }
}
