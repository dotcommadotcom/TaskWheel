import XCTest
import DequeModule
@testable import TaskWheel

final class TaskListVMTests: XCTestCase {
    
    private var simpleTaskVM: TaskViewModel!
    private var multipleTaskVM: TaskViewModel!
    private var orderVM: TaskViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        simpleTaskVM = TaskViewModel()
        multipleTaskVM = TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples)
        
        let taskList = TaskListModel(title: "my tasks")
        let tasks: Deque<TaskModel> = [
            TaskModel(title: "0", ofTaskList: taskList.id, priority: 3, date: date(2023, 6, 28)),
            TaskModel(title: "1", ofTaskList: taskList.id, priority: 0, date: date(2023, 3, 4)),
            TaskModel(title: "2", ofTaskList: taskList.id, priority: 2),
            TaskModel(title: "3", ofTaskList: taskList.id, priority: 1, date: date(2023, 3, 4)),
            TaskModel(title: "4", ofTaskList: taskList.id, priority: 0, date: date(2023, 3, 3)),
        ]
        orderVM = TaskViewModel(tasks, Deque([taskList]))
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        simpleTaskVM = nil
        multipleTaskVM = nil
        orderVM = nil
    }
    
    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents)!
    }
    
    // TEST - Ordering
    
    func testDateOrder() throws {
        let expected = [4, 1, 3, 0, 2]
        orderVM.updateCurrentOrder(to: .date)
        
        let ordered = orderVM.currentTasks().map { Int($0.title) ?? 0 }
        
        XCTAssertEqual(ordered, expected)
    }
    
    func testPriorityOrder() throws {
        let expected = [1, 4, 3, 2, 0]
        orderVM.updateCurrentOrder(to: .priority)
        
        let ordered = orderVM.currentTasks().map { Int($0.title) ?? 0 }
        
        XCTAssertEqual(ordered, expected)
    }
    
    func testManualOrder() throws {
        let expected = [0, 1, 2, 3, 4]
        orderVM.updateCurrentOrder(to: .manual)
        
        let ordered = orderVM.currentTasks().map { Int($0.title) ?? 0 }
        
        XCTAssertEqual(ordered, expected)
    }
    
    // TEST - Update current task list
    
    func testUpdateCurrentOrder() throws {
        multipleTaskVM.updateCurrentTo(this: multipleTaskVM.taskLists[2])
        let previousOrder = multipleTaskVM.currentOrder()
        
        multipleTaskVM.updateCurrentOrder(to: .priority)
        
        XCTAssertNotEqual(multipleTaskVM.currentOrder(), previousOrder)
    }
    
    func testUpdateCurrentTitle() throws {
        multipleTaskVM.updateCurrentTo(this: multipleTaskVM.taskLists[2])
        let previousTitle = multipleTaskVM.currentTitle()
        
        multipleTaskVM.updateCurrentTitle(to: "whats up")
        
        XCTAssertNotEqual(multipleTaskVM.currentTitle(), previousTitle)
    }
    
    func testUpdateCurrentIsStillSameTaskList() throws {
        let previousID = multipleTaskVM.currentTaskList().id
        
        multipleTaskVM.updateCurrentTitle(to: "whats up")
        
        XCTAssertEqual(multipleTaskVM.currentTaskList().id, previousID)
    }
    
    // TEST - Toggle isDoneVisible
    
    func testGetCurrentDoneTasksIsEmpty() throws {
        multipleTaskVM.toggleCurrentDoneVisible()

        let currentTasks = multipleTaskVM.currentDoneTasks()
        
        XCTAssertTrue(currentTasks.isEmpty)
    }
    
    func testCurrentTaskListDoneVisible() throws {
        let previousDoneVisible = multipleTaskVM.currentTaskList().isDoneVisible
        
        multipleTaskVM.toggleCurrentDoneVisible()

        XCTAssertNotEqual(multipleTaskVM.currentTaskList().isDoneVisible,  previousDoneVisible)
    }
    
    // TEST - Delete task list
    
    func testDeleteCurrentUpdatesCurrentTaskList() throws {
        let current = multipleTaskVM.current
        multipleTaskVM.updateCurrentTo(this: multipleTaskVM.taskLists[3])
        
        multipleTaskVM.deleteList(at: multipleTaskVM.current)
        
        XCTAssertEqual(multipleTaskVM.taskLists[current], multipleTaskVM.taskLists[0])
    }
    
    func testDeleteListDeletesAllTasksInList() throws {
        let previousTaskList = multipleTaskVM.taskLists[2]
        
        multipleTaskVM.deleteList(at: 2)
        
        XCTAssertTrue(multipleTaskVM.tasks.allSatisfy { $0.ofTaskList != previousTaskList.id })
    }

    func testDeleteListPreventsDeletingDefault() throws {
        let defaultTaskList = multipleTaskVM.defaultTaskList
        
        multipleTaskVM.deleteList(at: 0)
        
        XCTAssertTrue(multipleTaskVM.taskLists.contains(defaultTaskList))
    }

    func testDeleteList() throws {
        let deleted = multipleTaskVM.taskLists[2]
        
        multipleTaskVM.deleteList(at: 2)
        
        XCTAssertTrue(multipleTaskVM.taskLists.allSatisfy { $0.id != deleted.id })
    }
    
    // TEST - Add task list
    
    func testAddTaskListUpdatesCurrent() throws {
        simpleTaskVM.addTaskList(title: "new task list")
        
        let lastTaskList = simpleTaskVM.taskLists.last?.id
        
        XCTAssertEqual(simpleTaskVM.currentTaskList().id, lastTaskList)
    }
    
    func testAddTaskListAppends() throws {
        multipleTaskVM.addTaskList(title: "new task list")
        
        XCTAssertEqual(multipleTaskVM.taskLists[4].title, "new task list")
    }
    
    func testAddTaskList() throws {
        simpleTaskVM.addTaskList(title: "new task list")
        
        XCTAssertEqual(simpleTaskVM.taskLists.count, 2)
    }
    
    // TEST - Default task list
    
    func testUpdateDefaultSetsCurrent() throws {
        multipleTaskVM.updateCurrentTo(this: multipleTaskVM.taskLists[2])
        
        multipleTaskVM.updateDefault(with: 3)
        
        XCTAssertEqual(multipleTaskVM.current, 0)
    }

    func testUpdateDefaultWithIndex() throws {
        let targetTaskList = multipleTaskVM.taskLists[2]
        
        multipleTaskVM.updateDefault(with: 2)
        
        XCTAssertEqual(multipleTaskVM.defaultTaskList, targetTaskList)
    }
    
    func testUpdateDefaultMaintainsOrder() throws {
        let targetIndex = 1
        let previousFirst = multipleTaskVM.taskLists[0]
        
        multipleTaskVM.updateDefault(with: targetIndex)
        
        XCTAssertEqual(multipleTaskVM.taskLists[1], previousFirst)
    }
    
    func testUpdateDefaultRemoves() throws {
        let targetIndex = 3
        let targetTaskList = multipleTaskVM.taskLists[targetIndex]
        
        multipleTaskVM.updateDefault(with: targetIndex)
        
        XCTAssertNotEqual(multipleTaskVM.taskLists[targetIndex], targetTaskList)
    }
    
    func testUpdateDefaultPrepends() throws {
        let targetIndex = 2
        let targetTaskList = multipleTaskVM.taskLists[targetIndex]
        
        multipleTaskVM.updateDefault(with: targetIndex)
        
        XCTAssertEqual(multipleTaskVM.taskLists[0], targetTaskList)
    }
    
    func testUpdateDefaultDoesNothing() throws {
        let previousDefault = multipleTaskVM.defaultTaskList
        
        multipleTaskVM.updateDefault(with: 0)
        
        XCTAssertEqual(multipleTaskVM.defaultTaskList, previousDefault)
    }
    
    func testInitialDefaultIsFirst() throws {
        XCTAssertEqual(simpleTaskVM.defaultTaskList, simpleTaskVM.taskLists[0])
    }
    
    // TEST - Current task list

    func testUpdateCurrentTaskList() throws {
        let previousTaskList = multipleTaskVM.taskLists[2]
        
        multipleTaskVM.updateCurrentTo(this: previousTaskList)
        
        XCTAssertEqual(multipleTaskVM.current, 2)
    }
    
    func testCurrentDoneTasks() throws {
        let currentTasks = multipleTaskVM.currentDoneTasks()
        
        XCTAssertTrue(currentTasks.allSatisfy { 
            $0.ofTaskList == multipleTaskVM.currentTaskList().id && $0.isDone })
    }
    
    func testCurrentTasks() throws {
        let currentTasks = multipleTaskVM.currentTasks()
        
        XCTAssertTrue(currentTasks.allSatisfy { 
            $0.ofTaskList == multipleTaskVM.currentTaskList().id && !$0.isDone })
    }
    
    func testInitialCurrentIsFirst() throws {
        XCTAssertEqual(simpleTaskVM.currentTaskList().id, simpleTaskVM.taskLists[0].id)
    }

    // TEST - Constructor
    
    func testMultipleTaskLists() throws {
        XCTAssertEqual(multipleTaskVM.taskLists.count, 4)
    }
    
    func testTaskListsIsNeverEmpty() throws {
        XCTAssertEqual(simpleTaskVM.taskLists[0].title, "My Tasks")
    }
}
