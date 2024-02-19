import Foundation

class TaskViewModel: ObservableObject {
    @Published var taskList: [TaskModel]
    
    init(_ taskList: [TaskModel] = []) {
        self.taskList = taskList
    }

    func addTask(_ task: TaskModel) {
        if task.isTitleValid() {
            taskList.append(task)
        }
    }
    
    func toggleComplete(_ task: TaskModel) {
        if let index = taskList.firstIndex(where: { $0.id == task.id }) {
            taskList[index] = task.toggleComplete()
        }
    }
}
