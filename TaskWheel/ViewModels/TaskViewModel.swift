import Foundation
import DequeModule

class TaskViewModel: ObservableObject {
    @Published var taskList = Deque<TaskModel>()
    
    init(_ taskList: Deque<TaskModel> = []) {
        self.taskList = taskList
    }

    func add(title: String = "", details: String = "", priority: Int = 4) {
        taskList.prepend(TaskModel(title: title, details: details, priority: priority))
    }
    
    func toggleComplete(task: TaskModel) {
        if let index = taskList.firstIndex(where: { $0.id == task.id }) {
            taskList[index] = task.toggleComplete()
        }
    }
    
    func delete(task: TaskModel) {
        if let index = taskList.firstIndex(where: { $0.id == task.id }) {
            taskList.remove(at: index)
        }
    }
    
    func update(task: TaskModel, title: String? = nil, isComplete: Bool? = nil, details: String? = nil, priority: Int? = nil) {
        if let index = taskList.firstIndex(where: { $0.id == task.id }) {
            taskList[index] = task.edit(title: title ?? task.title,
                                        details: details ?? task.details,
                                        priority: priority ?? task.priority)
        }
    }
    
//    func showTasks() -> Deque<TaskModel> {
//        return taskList.filter { !$0.isComplete }
//    }
}
