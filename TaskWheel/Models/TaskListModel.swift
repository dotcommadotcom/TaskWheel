import Foundation
import DequeModule

struct TaskListModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let isDoneVisible: Bool
    let order: OrderItem
    
    init(
        id: UUID = UUID(),
        title: String,
        isDoneVisible: Bool = true,
        order: OrderItem = .manual
    ) {
        self.id = id
        self.title = title
        self.isDoneVisible = isDoneVisible
        self.order = order
    }
    
    func edit(title: String? = nil, isDoneVisible: Bool? = nil, order: OrderItem? = .manual) -> TaskListModel {
        return TaskListModel(id: self.id,
                             title: title ?? self.title,
                             isDoneVisible: isDoneVisible ?? self.isDoneVisible,
                             order: order ?? self.order)
    }
    
    func toggleDoneVisible()  -> TaskListModel {
        return edit(isDoneVisible: !self.isDoneVisible)
    }
}
