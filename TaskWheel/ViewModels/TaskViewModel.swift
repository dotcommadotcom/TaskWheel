import Foundation
import DequeModule

class TaskViewModel: ObservableObject {
    @Published var tasks: Deque<TaskModel>
    @Published var taskLists: Deque<TaskListModel>
    @Published var defaultTaskList: TaskListModel
    
    init(_ tasks: Deque<TaskModel> = [], _ taskLists: Deque<TaskListModel> = []) {
        self.tasks = tasks
        let backupTaskList = TaskListModel(title: "My Tasks")
        self.taskLists = taskLists.isEmpty ? [backupTaskList] : taskLists
        self.defaultTaskList = taskLists.first ?? backupTaskList
    }
    
    func add(title: String = "", details: String = "", priority: Int = 4) {
        tasks.prepend(TaskModel(title: title, details: details, priority: priority))
    }
    
    func toggleComplete(task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task.toggleComplete()
        }
    }
    
    func delete(task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
    
    func deleteCompleted(task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
    
    func update(task: TaskModel, title: String? = nil, isComplete: Bool? = nil, details: String? = nil, priority: Int? = nil) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task.edit(title: title ?? task.title,
                                     details: details ?? task.details,
                                     priority: priority ?? task.priority)
        }
    }
    
    func getIncompleteTasks() -> Deque<TaskModel> {
        return tasks.filter { !$0.isComplete }
    }
    
    func getCompletedTasks() -> Deque<TaskModel> {
        return tasks.filter { $0.isComplete }
    }
    
    
    //    func showTasks() -> Deque<TaskModel> {
    //        return taskList.filter { !$0.isComplete }
    //    }
    
    
    //    func filter(_ condition: (TaskModel) -> Bool) -> Deque<TaskModel> {
    //        return taskList.filter { task in condition(task) }
    //    }
}

extension TaskViewModel {
    
    func examples() -> TaskViewModel {
        
        let sampleTaskLists: Deque<TaskListModel> = [
            .init(title: "chores"),
            .init(title: "homework"),
            .init(title: "job search"),
            .init(title: "to buy"),
        ]
        
        let sampleDefault = sampleTaskLists[0].id
        
        let examples: Deque<TaskModel> = [
            .init(title: "laundry", ofTaskList: sampleDefault, isComplete: true),
            .init(title: "dishes", ofTaskList: sampleDefault, isComplete: true),
            .init(title: "vacuum", ofTaskList: sampleDefault, isComplete: true, priority: 1),
            .init(title: "mop", ofTaskList: sampleDefault, isComplete: false, details: "where are the clean mop heads?"),
            .init(title: "water plants", ofTaskList: sampleDefault, isComplete: false),
            .init(title: "throw out trash", ofTaskList: sampleDefault, isComplete: false, priority: 1),
            .init(title: "recycle plastic and paper, separate vinyl labels", ofTaskList: sampleDefault, isComplete: false),
            .init(title: "wipe countertop", ofTaskList: sampleDefault, isComplete: false),
            .init(title: "fold laundry", ofTaskList: sampleDefault, isComplete: false),
            .init(title: "clean bathroom", ofTaskList: sampleDefault, isComplete: false, priority: 2),
            .init(title: "organize shelf", ofTaskList: sampleDefault, isComplete: false),
            .init(title: "wipe mirror", ofTaskList: sampleDefault, isComplete: false, priority: 3),
            .init(title: "wipe windowsill", ofTaskList: sampleDefault, isComplete: false),
            .init(title: "sanitize toilet brushes", ofTaskList: sampleDefault, isComplete: false),
            .init(title: "call water company", ofTaskList: sampleDefault, isComplete: false),
        ]
    
        return TaskViewModel(examples, sampleTaskLists)
    }
    
}
