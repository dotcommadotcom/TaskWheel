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
    
    func update(
        this task: TaskModel,
        title: String? = nil,
        ofTaskList: UUID? = nil,
        details: String? = nil,
        priority: Int? = nil
    ) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task.edit(
                title: title,
                ofTaskList: ofTaskList,
                details: details,
                priority: priority
            )
        }
    }
    
    func changeDate(of task: TaskModel, to date: Date?) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task.changeDate(to: date)
        }
    }
    
    func moveTaskList(of task: TaskModel) {
        guard task.ofTaskList != currentId() else {
            return
        }
        
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            
            if !task.isDone, let taskListIndex = taskLists.firstIndex(where: { $0.id == task.ofTaskList }) {
                decrementListCount(taskListIndex)
            }
            
            tasks[index] = task.edit(ofTaskList: currentId())
            
            if !task.isDone {
                incrementListCount()
            }
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
        return Deque(tasks.filter { $0.ofTaskList == taskLists[current].id && $0.isDone && taskLists[current].isDoneVisible})
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
    
    // TEST
    func countDone() -> Int {
        return tasks.filter { $0.ofTaskList == taskLists[current].id && $0.isDone }.count
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
        case .dofirst:
            let spin = SpinViewModel()
            return { spin.score(of: $0) > spin.score(of: $1) }
        case .priority:
            return { $0.priority < $1.priority }
        case .date:
            return { ($0.date ?? .distantFuture) < ($1.date ?? .distantFuture) }
        default:
            return { _, _ in return false }
        }
    }
    
    func incrementListCount(_ index: Int = -1) {
        if index < 0 {
            taskLists[current] = taskLists[current].incrementCount()
        } else {
            taskLists[index] = taskLists[index].incrementCount()
        }
    }
    
    func decrementListCount(_ index: Int = -1) {
        if index < 0 {
            taskLists[current] = taskLists[current].decrementCount()
        } else {
            taskLists[index] = taskLists[index].decrementCount()
        }
    }
}
