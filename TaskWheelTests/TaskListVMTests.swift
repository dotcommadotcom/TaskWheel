import XCTest
import DequeModule
@testable import TaskWheel

final class TaskListVMTests: XCTestCase {
    
    private var simpleVM: TaskViewModel!
    private var multipleVM: TaskViewModel!
    private var orderVM: TaskViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        simpleVM = TaskViewModel()
        multipleVM = TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples)
        
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
        simpleVM = nil
        multipleVM = nil
        orderVM = nil
    }

    // TEST - Count
    
    func testMoveTaskListCallsIncrementAndDecrement() throws {
        multipleVM.moveTaskList(of: multipleVM.tasks[6])
        
        XCTAssertEqual(multipleVM.taskLists[0].count, 10)
        XCTAssertEqual(multipleVM.taskLists[1].count, 1)
    }
    
    func testDeleteCallsDecrement() throws {
        multipleVM.toggleDone(multipleVM.tasks[6])
        
        XCTAssertEqual(multipleVM.taskLists[0].count, 8)
    }
    
    func testToggleDoneCallsIncrementIfIsNotDone() throws {
        multipleVM.toggleDone(multipleVM.tasks[6])
        multipleVM.toggleDone(multipleVM.tasks[6])
        
        XCTAssertEqual(multipleVM.taskLists[0].count, 9)
    }
    
    func testToggleDoneCallsDecrementIfIsDone() throws {
        multipleVM.toggleDone(multipleVM.tasks[6])
        
        XCTAssertEqual(multipleVM.taskLists[0].count, 8)
    }
    
    func testAddTaskCallsIncrement() throws {
        multipleVM.addTask(title: "ninth task")
        
        XCTAssertEqual(multipleVM.taskLists[0].count, 10)
    }
    
    func testDecrementWithIndex() throws {
        multipleVM.decrementListCount(2)
        
        XCTAssertEqual(multipleVM.taskLists[2].count, 0)
    }
    
    func testIncrementWithIndex() throws {
        multipleVM.incrementListCount(2)
        
        XCTAssertEqual(multipleVM.taskLists[2].count, 2)
    }
    
    func testDecrement() throws {
        multipleVM.decrementListCount()
        
        XCTAssertEqual(multipleVM.taskLists[0].count, 8)
    }
    
    func testIncrement() throws {
        multipleVM.incrementListCount()
        
        XCTAssertEqual(multipleVM.taskLists[0].count, 10)
    }
    
    func testCountIsCorrect() throws {
        XCTAssertEqual(multipleVM.taskLists[0].count, multipleVM.currentTasks().count)
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
        multipleVM.updateCurrentTo(this: multipleVM.taskLists[2])
        let previousOrder = multipleVM.currentOrder()
        
        multipleVM.updateCurrentOrder(to: .priority)
        
        XCTAssertNotEqual(multipleVM.currentOrder(), previousOrder)
    }
    
    func testUpdateCurrentTitle() throws {
        multipleVM.updateCurrentTo(this: multipleVM.taskLists[2])
        let previousTitle = multipleVM.currentTitle()
        
        multipleVM.updateCurrentTitle(to: "whats up")
        
        XCTAssertNotEqual(multipleVM.currentTitle(), previousTitle)
    }
    
    func testUpdateCurrentIsStillSameTaskList() throws {
        let previousID = multipleVM.currentId()
        
        multipleVM.updateCurrentTitle(to: "whats up")
        
        XCTAssertEqual(multipleVM.currentId(), previousID)
    }
    
    // TEST - Toggle isDoneVisible
    
    func testGetCurrentDoneTasksIsEmpty() throws {
        multipleVM.toggleCurrentDoneVisible()

        let currentTasks = multipleVM.currentDoneTasks()
        
        XCTAssertTrue(currentTasks.isEmpty)
    }
    
    func testCurrentTaskListDoneVisible() throws {
        let previousDoneVisible = multipleVM.taskLists[multipleVM.current].isDoneVisible
        
        multipleVM.toggleCurrentDoneVisible()

        XCTAssertNotEqual(multipleVM.taskLists[multipleVM.current].isDoneVisible,  previousDoneVisible)
    }
    
    // TEST - Delete done
    
    func testDeleteDone() throws {
        let doneDeleted = multipleVM.taskLists[0]
        
        multipleVM.deleteDone()
        
        XCTAssertTrue(multipleVM.tasks.contains(where: { task in
            if task.id == doneDeleted.id {
                return !task.isDone
            }
            return true
        }))
    }
    
    // TEST - Delete task list
    
    func testDeleteCurrentUpdatesCurrentTaskList() throws {
        let current = multipleVM.current
        multipleVM.updateCurrentTo(this: multipleVM.taskLists[3])
        
        multipleVM.deleteList(at: multipleVM.current)
        
        XCTAssertEqual(multipleVM.taskLists[current], multipleVM.taskLists[0])
    }
    
    func testDeleteListDeletesAllTasksInList() throws {
        let previousTaskList = multipleVM.taskLists[2]
        
        multipleVM.deleteList(at: 2)
        
        XCTAssertTrue(multipleVM.tasks.allSatisfy { $0.ofTaskList != previousTaskList.id })
    }

    func testDeleteListPreventsDeletingDefault() throws {
        let defaultTaskList = multipleVM.defaultTaskList
        
        multipleVM.deleteList(at: 0)
        
        XCTAssertTrue(multipleVM.taskLists.contains(defaultTaskList))
    }

    func testDeleteList() throws {
        let deleted = multipleVM.taskLists[2]
        
        multipleVM.deleteList(at: 2)
        
        XCTAssertTrue(multipleVM.taskLists.allSatisfy { $0.id != deleted.id })
    }
    
    // TEST - Add task list
    
    func testAddTaskListUpdatesCurrent() throws {
        simpleVM.addTaskList(title: "new task list")
        
        let lastTaskList = simpleVM.taskLists.last?.id
        
        XCTAssertEqual(simpleVM.currentId(), lastTaskList)
    }
    
    func testAddTaskListAppends() throws {
        multipleVM.addTaskList(title: "new task list")
        
        XCTAssertEqual(multipleVM.taskLists[4].title, "new task list")
    }
    
    func testAddTaskList() throws {
        simpleVM.addTaskList(title: "new task list")
        
        XCTAssertEqual(simpleVM.taskLists.count, 2)
    }
    
    // TEST - Default task list
    
    func testUpdateDefaultSetsCurrent() throws {
        multipleVM.updateCurrentTo(this: multipleVM.taskLists[2])
        
        multipleVM.updateDefault(with: 3)
        
        XCTAssertEqual(multipleVM.current, 0)
    }

    func testUpdateDefaultWithIndex() throws {
        let targetTaskList = multipleVM.taskLists[2]
        
        multipleVM.updateDefault(with: 2)
        
        XCTAssertEqual(multipleVM.defaultTaskList, targetTaskList)
    }
    
    func testUpdateDefaultMaintainsOrder() throws {
        let targetIndex = 1
        let previousFirst = multipleVM.taskLists[0]
        
        multipleVM.updateDefault(with: targetIndex)
        
        XCTAssertEqual(multipleVM.taskLists[1], previousFirst)
    }
    
    func testUpdateDefaultRemoves() throws {
        let targetIndex = 3
        let targetTaskList = multipleVM.taskLists[targetIndex]
        
        multipleVM.updateDefault(with: targetIndex)
        
        XCTAssertNotEqual(multipleVM.taskLists[targetIndex], targetTaskList)
    }
    
    func testUpdateDefaultPrepends() throws {
        let targetIndex = 2
        let targetTaskList = multipleVM.taskLists[targetIndex]
        
        multipleVM.updateDefault(with: targetIndex)
        
        XCTAssertEqual(multipleVM.taskLists[0], targetTaskList)
    }
    
    func testUpdateDefaultDoesNothing() throws {
        let previousDefault = multipleVM.defaultTaskList
        
        multipleVM.updateDefault(with: 0)
        
        XCTAssertEqual(multipleVM.defaultTaskList, previousDefault)
    }
    
    func testInitialDefaultIsFirst() throws {
        XCTAssertEqual(simpleVM.defaultTaskList, simpleVM.taskLists[0])
    }
    
    // TEST - Current task list

    func testUpdateCurrentTaskList() throws {
        let previousTaskList = multipleVM.taskLists[2]
        
        multipleVM.updateCurrentTo(this: previousTaskList)
        
        XCTAssertEqual(multipleVM.current, 2)
    }
    
    func testCurrentDoneTasks() throws {
        let currentTasks = multipleVM.currentDoneTasks()
        
        XCTAssertTrue(currentTasks.allSatisfy { 
            $0.ofTaskList == multipleVM.currentId() && $0.isDone })
    }
    
    func testCurrentTasks() throws {
        let currentTasks = multipleVM.currentTasks()
        
        XCTAssertTrue(currentTasks.allSatisfy { 
            $0.ofTaskList == multipleVM.currentId() && !$0.isDone })
    }
    
    func testInitialCurrentIsFirst() throws {
        XCTAssertEqual(simpleVM.currentId(), simpleVM.taskLists[0].id)
    }

    // TEST - Constructor
    
    func testMultipleTaskLists() throws {
        XCTAssertEqual(multipleVM.taskLists.count, 4)
    }
    
    func testTaskListsIsNeverEmpty() throws {
        XCTAssertEqual(simpleVM.taskLists[0].title, "My Tasks")
    }
}
