import Foundation
import DequeModule

class TaskViewModel: ObservableObject {
    @Published var taskList = Deque<TaskModel>()
    
    init(_ taskList: Deque<TaskModel> = []) {
        self.taskList = taskList
    }

    func addTask(title: String) {
        taskList.prepend(TaskModel(title: title))
    }
    
    func toggleComplete(_ task: TaskModel) {
        if let index = taskList.firstIndex(where: { $0.id == task.id }) {
            taskList[index] = task.toggleComplete()
        }
    }
    
    func deleteTask(_ task: TaskModel) {
        if let index = taskList.firstIndex(where: { $0.id == task.id }) {
            taskList[index] = task.markDeleted()
        }
    }
    
    func showTasks() -> Deque<TaskModel> {
        return taskList.filter { !$0.isDeleted }
    }
}
