import Foundation
import DequeModule

struct TaskListModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let isDoneVisible: Bool
    let count: Int
    let order: OrderItem
    
    init(
        id: UUID = UUID(),
        title: String,
        isDoneVisible: Bool = true,
        count: Int = 0,
        order: OrderItem = .manual
    ) {
        self.id = id
        self.title = title
        self.isDoneVisible = isDoneVisible
        self.count = count
        self.order = order
    }
    
    func edit(
        title: String? = nil,
        isDoneVisible: Bool? = nil,
        count: Int? = nil,
        order: OrderItem? = nil
    ) -> TaskListModel {
        return TaskListModel(
            id: self.id,
            title: title ?? self.title,
            isDoneVisible: isDoneVisible ?? self.isDoneVisible,
            count: count ?? self.count,
            order: order ?? self.order
        )
    }
    
    func toggleDoneVisible()  -> TaskListModel {
        return edit(isDoneVisible: !self.isDoneVisible)
    }
    
    func incrementCount()  -> TaskListModel {
        return edit(count: self.count + 1)
    }
    
    func decrementCount()  -> TaskListModel {
        return edit(count: self.count - 1)
    }
}
