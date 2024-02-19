import Foundation

class TaskViewModel {
    @Published var taskList: [TaskModel] = []
    
    init() {
        getExamples()
    }
    
    func getExamples() {
        taskList.append(contentsOf: TaskModel.examples)
    }
}
