import Foundation
import DequeModule

class TaskViewModel: ObservableObject {
    @Published var taskList = Deque<TaskModel>()
    
    init(_ taskList: Deque<TaskModel> = []) {
        self.taskList = taskList
    }

    func addTask(title: String, details: String = "") {
        taskList.prepend(TaskModel(title: title, details: details))
    }
    
    func toggleComplete(_ task: TaskModel) {
        if let index = taskList.firstIndex(where: { $0.id == task.id }) {
            taskList[index] = task.toggleComplete()
        }
    }

    
//    func deleteTask(indexSet: IndexSet) {
//        taskList.remove(atOffsets: indexSet)
//    }
//    
//    func showTasks() -> Deque<TaskModel> {
//        return taskList.filter { !$0.isComplete }
//    }
}
