import Foundation
import DequeModule

class TaskViewModel: ObservableObject {
    @Published var tasks: Deque<TaskModel>
    @Published var taskLists: Deque<TaskListModel>
    @Published var defaultTaskList: TaskListModel
    @Published var currentTaskList: TaskListModel
    
    init(_ tasks: Deque<TaskModel> = [], _ taskLists: Deque<TaskListModel> = []) {
        self.tasks = tasks
        let backupTaskList = TaskListModel(title: "My Tasks")
        self.taskLists = taskLists.isEmpty ? [backupTaskList] : taskLists
        self.defaultTaskList = taskLists.first ?? backupTaskList
        self.currentTaskList = taskLists.first ?? backupTaskList
    }
    
    func addTask(title: String = "", details: String = "", priority: Int = 4) {
        tasks.prepend(TaskModel(title: title, details: details, priority: priority))
    }
    
    func toggleCompleteTask(_ task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task.toggleComplete()
        }
    }
    
    func deleteTask(_ task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
    
    func deleteMultipleTasks(condition: @escaping (TaskModel) -> Bool) {
        tasks.removeAll(where: condition)
    }
    
    func updateTask(_ task: TaskModel, title: String? = nil, isComplete: Bool? = nil, details: String? = nil, priority: Int? = nil) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task.edit(title: title ?? task.title,
                                     details: details ?? task.details,
                                     priority: priority ?? task.priority)
        }
    }
    
    func getCurrentTasks() -> Deque<TaskModel> {
        return tasks.filter { $0.ofTaskList == currentTaskList.id && !$0.isComplete }
    }
    
    func getCurrentCompletedTasks() -> Deque<TaskModel> {
        return tasks.filter { $0.ofTaskList == currentTaskList.id && $0.isComplete }
    }
    
    func getCurrentTitle() -> String {
        return self.currentTaskList.title
    }
    
    func updateCurrentTaskList(_ taskList: TaskListModel) {
        self.currentTaskList = taskList
    }
    
    func toggleCurrentDoneVisible() {
        if let index = taskLists.firstIndex(where: { $0.id == currentTaskList.id }) {
            taskLists[index] = taskLists[index].toggleDoneVisible()
            updateCurrentTaskList(taskLists[index])
        }
    }
    
    func updateDefaultTaskList(_ taskList: TaskListModel) {
        self.defaultTaskList = taskList
    }
    
    func addTaskList(title: String) {
        let newTaskList = TaskListModel(title: title)
        
        taskLists.append(newTaskList)
        
        updateCurrentTaskList(newTaskList)
    }
    
    func deleteTaskList(_ taskList: TaskListModel) {
        guard taskLists.count > 1 else {
            return
        }
        
        if let index = taskLists.firstIndex(where: { $0.id == taskList.id }) {
            let targetID = taskLists[index].id
            
            deleteMultipleTasks { $0.ofTaskList == targetID }
            taskLists.remove(at: index)
            
            if let firstTaskList = taskLists.first {
                if targetID == defaultTaskList.id {
                    updateDefaultTaskList(firstTaskList)
                }
                
                if targetID == currentTaskList.id {
                    updateCurrentTaskList(firstTaskList)
                }
            }
            
        }
    }

    
    func updateTaskList(_ taskList: TaskListModel, title: String? = nil) {
        if let index = taskLists.firstIndex(where: { $0.id == taskList.id }) {
            taskLists[index] = taskList.edit(title: title ?? taskList.title)
        }
    }
    
    
    //    func showTasks() -> Deque<TaskModel> {
    //        return taskList.filter { !$0.isComplete }
    //    }
    
    
    //    func filter(_ condition: (TaskModel) -> Bool) -> Deque<TaskModel> {
    //        return taskList.filter { task in condition(task) }
    //    }
}

extension TaskViewModel {
    
    static let examples: Deque<TaskListModel> = [
        .init(title: "chores"),
        .init(title: "notes"),
        .init(title: "digital cleanse"),
        .init(title: "to buy"),
    ]
    
    static let uuids = examples.map { $0.id }
    
    static func tasksExamples() -> Deque<TaskModel> {
        [
            .init(title: "laundry", ofTaskList: uuids[0], isComplete: true),
            .init(title: "research pkms", ofTaskList: uuids[2], isComplete: false),
            .init(title: "dishes", ofTaskList: uuids[0], isComplete: false),
            .init(title: "mop", ofTaskList: uuids[0], isComplete: false, details: "where are the clean mop heads?", priority: 2),
            .init(title: "i hope im not too late to set my demon straight", ofTaskList: uuids[1], isComplete: false, priority: 1),
            .init(title: "vacuum", ofTaskList: uuids[0], isComplete: true, priority: 1),
            .init(title: "its all a big circle jerk", ofTaskList: uuids[1], isComplete: false),
            .init(title: "water plants", ofTaskList: uuids[0], isComplete: false),
            .init(title: "throw out trash", ofTaskList: uuids[0], isComplete: false, priority: 1),
            .init(title: "recycle plastic and paper, separate vinyl labels", ofTaskList: uuids[0], isComplete: false),
            .init(title: "wipe countertop", ofTaskList: uuids[0], isComplete: false),
            .init(title: "fold laundry", ofTaskList: uuids[0], isComplete: false),
            .init(title: "change passwords", ofTaskList: uuids[2], isComplete: true),
            .init(title: "clean bathroom", ofTaskList: uuids[0], isComplete: true, priority: 2),
            .init(title: "organize shelf", ofTaskList: uuids[0], isComplete: false, priority: 3),
            .init(title: "i want to make [] things, even if nobody cares", ofTaskList: uuids[1], isComplete: true),
        ]
    }
    
}
