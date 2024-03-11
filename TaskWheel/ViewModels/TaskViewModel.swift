import Foundation
import DequeModule

class TaskViewModel: ObservableObject {
    @Published var tasks: Deque<TaskModel>
    @Published var taskLists: Deque<TaskListModel>
    @Published var defaultTaskList: TaskListModel
    @Published var current: Int
    
    init(
        _ tasks: Deque<TaskModel> = [],
        _ taskLists: Deque<TaskListModel> = []
    ) {
        self.tasks = tasks
        
        let backupTaskList = TaskListModel(title: "My Tasks")
        self.taskLists = taskLists.isEmpty ? [backupTaskList] : taskLists
        self.defaultTaskList = taskLists.first ?? backupTaskList
        self.current = 0
    }
}

extension TaskViewModel {
    
    func addTask(title: String = "", details: String = "", priority: Int = 3, date: Date? = nil) {
        tasks.prepend(TaskModel(title: title, ofTaskList: taskLists[current].id, details: details, priority: priority, date: date))
        incrementListCount()
        objectWillChange.send()
    }
    
    func toggleDone(_ task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task.toggleDone()
            if tasks[index].isDone {
                decrementListCount()
            } else {
                incrementListCount()
            }
        }
    }
    
    func delete(this task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
            decrementListCount()
        }
    }
    
    func deleteIf(condition: @escaping (TaskModel) -> Bool) {
        tasks.removeAll(where: condition)
    }
    
    func update(this task: TaskModel, title: String? = nil, ofTaskList: UUID? = nil, isDone: Bool? = nil, details: String? = nil, priority: Int? = nil, date: Date? = nil) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task.edit(title: title ?? task.title,
                                     ofTaskList: ofTaskList ?? task.ofTaskList,
                                     details: details ?? task.details,
                                     priority: priority ?? task.priority,
                                     date: date ?? task.date)
        }
    }
}

extension TaskViewModel {
    
    func currentTitle() -> String {
        return self.taskLists[current].title
    }
    
    func currentId() -> UUID {
        return self.taskLists[current].id
    }
    
    func currentCount() -> Int {
        return self.taskLists[current].count
    }

    func currentOrder() -> OrderItem {
        return self.taskLists[current].order
    }
            
    func currentTasks() -> Deque<TaskModel> {
        return Deque(tasks.filter { $0.ofTaskList == taskLists[current].id && !$0.isDone }.sorted(by: ordering()))
    }
    
    func currentDoneTasks() -> Deque<TaskModel> {
        guard taskLists[current].isDoneVisible else {
            return []
        }
        
        return Deque(tasks.filter { $0.ofTaskList == taskLists[current].id && $0.isDone }.sorted(by: ordering()))
    }
    
    func updateCurrentTo(this taskList: TaskListModel) {
        if let index = taskLists.firstIndex(where: { $0.id == taskList.id }) {
            self.current = index
        }
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
    
    func deleteDone() {
        deleteIf { $0.isDone && $0.ofTaskList == self.currentId()}
    }
    
    func toggleCurrentDoneVisible() {
        taskLists[current] = taskLists[current].toggleDoneVisible()
    }
    
    func updateCurrentTitle(to title: String? = nil) {
        taskLists[current] = taskLists[current].edit(title: title)
    }
    
    func updateCurrentOrder(to order: OrderItem) {
        taskLists[current] = taskLists[current].edit(order: order)
    }
    
    func ordering() -> (TaskModel, TaskModel) -> Bool {
        switch currentOrder() {
        case .priority:
            return { $0.priority < $1.priority }
        case .date:
            return { ($0.date ?? .distantFuture) < ($1.date ?? .distantFuture) }
        case .manual:
            return { _, _ in return false }
        }
    }
    
    func incrementListCount() {
        taskLists[current] = taskLists[current].incrementCount()
    }
    
    func decrementListCount() {
        taskLists[current] = taskLists[current].decrementCount()
    }
}

extension TaskViewModel {
    
    static let examples: Deque<TaskListModel> = [
        .init(title: "chores", count: 9),
        .init(title: "notes", count: 2),
        .init(title: "digital cleanse", count: 1),
        .init(title: "to buy", count: 0),
    ]
    
    static let uuids = examples.map { $0.id }
    
    static let creations: [Date] = {
        var dateArray = [Date]()
        let calendar = Calendar.current
        let today = Date()

        dateArray.append(Date())
        
        for i in [2, 52, 365] {
            if let pastDate = calendar.date(byAdding: .day, value: -i, to: today) {
                dateArray.append(pastDate)
            }
        }
        return dateArray
    }()
    
    static let due: [Date] = {
        var dateArray = [Date]()
        let calendar = Calendar.current
        let today = Date()

        for i in [14, 1] {
            if let pastDate = calendar.date(byAdding: .day, value: -i, to: today) {
                dateArray.append(pastDate)
            }
        }

        dateArray.append(today)

        for i in [3, 16] {
            if let futureDate = calendar.date(byAdding: .day, value: i, to: today) {
                dateArray.append(futureDate)
            }
        }

        return dateArray
    }()
    
    static func tasksExamples() -> Deque<TaskModel> {
        [
            .init(
                  title: "laundry", 
                  ofTaskList: uuids[0],
                  isDone: false,
                  date: due[0]),
            
            .init(title: "research pkms", 
                  ofTaskList: uuids[2],
                  isDone: false),
            
            .init(creation: creations[0],
                  title: "dishes",
                  ofTaskList: uuids[0],
                  isDone: false,
                  priority: 0),
            
            .init(
                  title: "mop", 
                  ofTaskList: uuids[0],
                  isDone: false,
                  details: "where are the clean mop heads?", 
                  priority: 1,
                  date: due[1]),
            
            .init(title: "i hope im not too late to set my demon straight", 
                  ofTaskList: uuids[1], isDone: false, priority: 0),
            
            .init(
                  title: "vacuum", ofTaskList: uuids[0], isDone: true, 
                  priority: 1),
            
            .init(title: "its all a big circle jerk", 
                  ofTaskList: uuids[1], 
                  isDone: false),
            
            .init(creation: creations[1],
                  title: "water plants",
                  ofTaskList: uuids[0],
                  isDone: false,
                  priority: 2),
            
            .init(
                  title: "throw out trash", 
                  ofTaskList: uuids[0],
                  isDone: false, 
                  priority: 0,
                  date: due[2]),
            
            .init(creation: creations[2],
                  title: "recycle plastic and paper, separate vinyl labels",
                  ofTaskList: uuids[0], isDone: false),
            
            .init(creation: creations[3],
                  title: "wipe countertop", ofTaskList: uuids[0],
                  isDone: false),
            
            .init(
                  title: "fold laundry", ofTaskList: uuids[0], isDone: false,
                  date: due[3]),
            
            .init(title: "change passwords", ofTaskList: uuids[2], isDone: true),
            
            .init(
                  title: "clean bathroom", ofTaskList: uuids[0], 
                  isDone: true,
                  priority: 1,
                  date: due[4]),
            
            .init(
                  title: "organize shelf",
                  ofTaskList: uuids[0],
                  isDone: false,
                  priority: 2,
                  date: due[4]),
            
            .init(title: "i want to make [] things, even if nobody cares", ofTaskList: uuids[1], isDone: true),
        ]
    }
    
}
