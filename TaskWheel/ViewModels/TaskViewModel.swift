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
    
    func toggleCompleteTask(task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task.toggleComplete()
        }
    }
    
    func deleteTask(task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
    
    func deleteMultipleTasks(condition: @escaping (TaskModel) -> Bool) {
        tasks.removeAll(where: condition)
    }

    func updateTask(task: TaskModel, title: String? = nil, isComplete: Bool? = nil, details: String? = nil, priority: Int? = nil) {
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

    func updateCurrentTaskList(taskList: TaskListModel) {
        self.currentTaskList = taskList
    }
    
    
    func updateDefaultTaskList(taskList: TaskListModel) {
        self.defaultTaskList = taskList
    }
    
    func addTaskList(title: String) {
        let newTaskList = TaskListModel(title: title)
        
        taskLists.append(newTaskList)
        
        updateCurrentTaskList(taskList: newTaskList)
    }
    
    func deleteTaskList(taskList: TaskListModel) {
        if let index = taskLists.firstIndex(where: { $0.id == taskList.id }) {
            taskLists.remove(at: index)
        }
    }
    
    func updateTaskList(taskList: TaskListModel, title: String? = nil) {
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
