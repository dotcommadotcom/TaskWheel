import Foundation
import DequeModule

class TaskViewModel: ObservableObject {
    @Published var tasks: Deque<TaskModel>
    @Published var taskLists: Deque<TaskListModel>
    @Published var defaultTaskList: TaskListModel
    @Published var current: Int
    
    init(_ tasks: Deque<TaskModel> = [], _ taskLists: Deque<TaskListModel> = []) {
        self.tasks = tasks
        let backupTaskList = TaskListModel(title: "My Tasks")
        self.taskLists = taskLists.isEmpty ? [backupTaskList] : taskLists
        self.defaultTaskList = taskLists.first ?? backupTaskList
        self.current = 0
    }
}

extension TaskViewModel {
    
    func addTask(title: String = "", details: String = "", priority: Int = 4) {
        tasks.prepend(TaskModel(title: title, ofTaskList: currentTaskList().id, details: details, priority: priority))
        objectWillChange.send()
    }
    
    func toggleDone(_ task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task.toggleDone()
        }
    }
    
    func delete(this task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
    
    func deleteIf(condition: @escaping (TaskModel) -> Bool) {
        tasks.removeAll(where: condition)
    }
    
    func update(this task: TaskModel, title: String? = nil, ofTaskList: UUID? = nil, isComplete: Bool? = nil, details: String? = nil, priority: Int? = nil) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task.edit(title: title ?? task.title,
                                     ofTaskList: ofTaskList ?? task.ofTaskList,
                                     details: details ?? task.details,
                                     priority: priority ?? task.priority)
        }
    }
    
    func currentTaskList() -> TaskListModel {
        return self.taskLists[current]
    }
    
    func currentTitle() -> String {
        return self.taskLists[current].title
    }
    
    func currentTasks() -> Deque<TaskModel> {
        return tasks.filter { $0.ofTaskList == taskLists[current].id && !$0.isDone }
    }
    
    func currentDoneTasks() -> Deque<TaskModel> {
        guard taskLists[current].isDoneVisible else {
            return []
        }
        
        return tasks.filter { $0.ofTaskList == taskLists[current].id && $0.isDone }
    }
    
    func updateCurrentTo(this taskList: TaskListModel) {
        if let index = taskLists.firstIndex(where: { $0.id == taskList.id }) {
            self.current = index
        }
    }
    
    func toggleCurrentDoneVisible() {
        taskLists[current] = taskLists[current].toggleDoneVisible()
    }
    
    func updateDefault(with index: Int) {
        guard taskLists[index].id != defaultTaskList.id else {
            return
        }
        
        let target = taskLists.remove(at: index)
        taskLists.prepend(target)
        self.defaultTaskList = taskLists[0]
        self.current = 0
    }
    
    func addTaskList(title: String) {
        taskLists.append(TaskListModel(title: title))
        self.current = taskLists.count - 1
    }
    
    func deleteList(at index: Int) {
        guard taskLists[index].id != defaultTaskList.id else {
            return
        }
        
        deleteIf { $0.ofTaskList == self.taskLists[index].id }

        if index == self.current {
            updateCurrentTo(this: defaultTaskList)
        }
        
        taskLists.remove(at: index)
    }
    
    func updateCurrentTitle(to title: String? = nil) {
        taskLists[current] = taskLists[current].edit(title: title)
    }
    
//    func countDone() -> Int {
//        return tasks.filter { $0.isDone }.count
//    }
    
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
