import Foundation

class TaskViewModel {
    @Published var taskList: [TaskModel] = []
    
//    init() {
//        getExamples()
//    }
    
    func getExamples() {
        taskList.append(contentsOf: TaskModel.examples)
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
