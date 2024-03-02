import XCTest
@testable import TaskWheel

final class TaskViewModelTests: XCTestCase {
    
    private var simpleTaskVM: TaskViewModel!
    private var multipleTaskVM: TaskViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        simpleTaskVM = TaskViewModel()
        multipleTaskVM = TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        simpleTaskVM = nil
        multipleTaskVM = nil
    }
    
//    // TEST - Update task list
//    
//    func testUpdateTaskListWithNothingChangesNothing() throws {
//        let current = multipleTaskVM.current
//        
//        multipleTaskVM.updateListTitle(title: "new title")
//        
//        XCTAssertEqual(multipleTaskVM.taskLists[2], previousTaskList)
//    }
//    
//    func testUpdateTaskListIsStillSameTaskList() throws {
//        let current = multipleTaskVM.current
//        let currentTaskList = multipleTaskVM.taskLists[
//        
//        multipleTaskVM.updateListTitle(title: "new title")
//        
//        XCTAssertEqual(multipleTaskVM.taskLists[0].id, previousTaskList.id)
//    }
//    
//    func testUpdateTaskList() throws {
//        let previousTaskList = multipleTaskVM.taskLists[2]
//        let previousTitle = previousTaskList.title
//        
//        multipleTaskVM.updateTaskList(previousTaskList, title: "whats up")
//        
//        XCTAssertNotEqual(multipleTaskVM.taskLists[2].title, previousTitle)
//    }
//    
//    // TEST - Delete task list
//    
//    func testDeleteCurrentUpdatesCurrentTaskList() throws {
//        let current = multipleTaskVM.current
//        multipleTaskVM.updateCurrentTaskList(multipleTaskVM.taskLists[3])
//        
//        multipleTaskVM.deleteTaskList(multipleTaskVM.taskLists[current])
//        
//        XCTAssertEqual(multipleTaskVM.taskLists[current], multipleTaskVM.taskLists[0])
//    }
//    
//    func testDeleteTaskListDeletesAllTasksInList() throws {
//        let previousTaskList = multipleTaskVM.taskLists[2]
//        
//        multipleTaskVM.deleteTaskList(previousTaskList)
//        
//        XCTAssertTrue(multipleTaskVM.taskLists.allSatisfy { $0.id != previousTaskList.id })
//    }
//    
//    func testDeleteTaskListPreventsDeletingDefault() throws {
//        let defaultTaskList = multipleTaskVM.defaultTaskList
//        
//        multipleTaskVM.deleteTaskList(multipleTaskVM.defaultTaskList)
//        
//        XCTAssertTrue(multipleTaskVM.taskLists.contains(defaultTaskList))
//    }
//    
//    func testDeleteTaskList() throws {
//        let previousTaskList = multipleTaskVM.taskLists[2]
//        
//        multipleTaskVM.deleteTaskList(previousTaskList)
//        
//        XCTAssertTrue(multipleTaskVM.taskLists.allSatisfy { $0.id != previousTaskList.id })
//    }
//    
//    // TEST - Add task list
//    
//    func testAddTaskListNewTaskListIDIsCurrent() throws {
//        let current = simpleTaskVM.current
//        simpleTaskVM.addTaskList(title: "new task list")
//        
//        let lastTaskList = simpleTaskVM.taskLists.last?.id
//        
//        XCTAssertEqual(simpleTaskVM.taskLists[current].id, lastTaskList)
//    }
//    
//    func testAddTaskListUpdatesCurrentTaskList() throws {
//        let current = simpleTaskVM.current
//        
//        simpleTaskVM.addTaskList(title: "new task list")
//        
//        XCTAssertEqual(simpleTaskVM.taskLists[current].title, "new task list")
//    }
//    
//    func testAddTaskListAppends() throws {
//        simpleTaskVM.addTaskList(title: "new task list")
//        
//        XCTAssertEqual(simpleTaskVM.taskLists[1].title, "new task list")
//    }
//    
//    func testAddTaskList() throws {
//        simpleTaskVM.addTaskList(title: "new task list")
//        
//        XCTAssertEqual(simpleTaskVM.taskLists.count, 2)
//    }
//    
//    // TEST - Default task list
//    
//    func testUpdateDefaultTaskListMaintainsOrder() throws {
//        let previousFirst = multipleTaskVM.taskLists[0]
//        
//        multipleTaskVM.updateDefaultTaskList(multipleTaskVM.taskLists[2])
//        
//        XCTAssertEqual(multipleTaskVM.taskLists[1], previousFirst)
//    }
//    
//    func testUpdateDefaultTaskListRemoves() throws {
//        let previousTaskList = multipleTaskVM.taskLists[2]
//        
//        multipleTaskVM.updateDefaultTaskList(previousTaskList)
//        
//        XCTAssertNotEqual(multipleTaskVM.taskLists[2], previousTaskList)
//    }
//    
//    func testUpdateDefaultTaskListPrepends() throws {
//        let previousTaskList = multipleTaskVM.taskLists[2]
//        
//        multipleTaskVM.updateDefaultTaskList(previousTaskList)
//        
//        XCTAssertEqual(multipleTaskVM.taskLists[0], previousTaskList)
//    }
//    
//    func testUpdateDefaultTaskList() throws {
//        let previousTaskList = multipleTaskVM.taskLists[2]
//        
//        multipleTaskVM.updateDefaultTaskList(previousTaskList)
//        
//        XCTAssertEqual(multipleTaskVM.defaultTaskList, previousTaskList)
//    }
//    
//    func testTaskListsInitialDefaultIsFirst() throws {
//        XCTAssertEqual(simpleTaskVM.taskLists[0], simpleTaskVM.defaultTaskList)
//    }
//    
//    // TEST - Current task list
//    
//    func testCurrentTaskListDoneVisible() throws {
//        let current = multipleTaskVM.current
//        multipleTaskVM.toggleCurrentDoneVisible()
//
//        XCTAssertFalse(multipleTaskVM.taskLists[current].isDoneVisible)
//    }
//    
//    func testUpdateCurrentTaskList() throws {
//        let current = multipleTaskVM.current
//        let previousTaskList = multipleTaskVM.taskLists[2]
//        
//        multipleTaskVM.updateCurrentTaskList(previousTaskList)
//        
//        XCTAssertEqual(multipleTaskVM.taskLists[current], previousTaskList)
//    }
//
//    func testGetCurrentTaskListTitle() throws {
//        XCTAssertEqual(multipleTaskVM.getCurrentTitle(), "chores")
//    }
//    
//    func testGetCurrentCompletedTasks() throws {
//        let current = multipleTaskVM.current
//        let currentTasks = multipleTaskVM.getCurrentCompletedTasks()
//        
//        XCTAssertTrue(currentTasks.allSatisfy { $0.ofTaskList == multipleTaskVM.taskLists[current].id && $0.isComplete })
//    }
//    
//    func testGetCurrentTasks() throws {
//        let current = multipleTaskVM.current
//        let currentTasks = multipleTaskVM.getCurrentTasks()
//        
//        XCTAssertTrue(currentTasks.allSatisfy { $0.ofTaskList == multipleTaskVM.taskLists[current].id && !$0.isComplete })
//    }
//    
//    func testTaskListsInitialCurrentIsFirst() throws {
//        let current = simpleTaskVM.current
//        
//        XCTAssertEqual(simpleTaskVM.taskLists[0], simpleTaskVM.taskLists[current])
//    }
//    
//    // TEST - Update task
//    
//    func testUpdateMultipleProperties() throws {
//        let previousTask = multipleTaskVM.tasks[6]
//        let previousTitle = previousTask.title
//        let previousDetails = previousTask.details
//        
//        multipleTaskVM.updateTask(previousTask, title: "new title", details: "lets add some more")
//        
//        XCTAssertNotEqual(multipleTaskVM.tasks[6].title, previousTitle)
//        XCTAssertNotEqual(multipleTaskVM.tasks[6].details, previousDetails)
//    }
//    
//    func testUpdateTaskWithNothingChangesNothing() throws {
//        let previousTask = multipleTaskVM.tasks[6]
//        
//        multipleTaskVM.updateTask(previousTask)
//        
//        XCTAssertEqual(multipleTaskVM.tasks[6], previousTask)
//    }
//    
//    func testUpdateTaskIsStillSameTask() throws {
//        let previousTask = multipleTaskVM.tasks[6]
//        
//        multipleTaskVM.updateTask(previousTask, priority: 2)
//        
//        XCTAssertEqual(multipleTaskVM.tasks[6].id, previousTask.id)
//    }
//    
//    func testUpdateTask() throws {
//        let previousTask = multipleTaskVM.tasks[6]
//        let previousPriority = previousTask.priority
//        
//        multipleTaskVM.updateTask(previousTask, priority: 2)
//        
//        XCTAssertNotEqual(multipleTaskVM.tasks[6].priority, previousPriority)
//    }
//    
//    // TEST - Delete task
//    
//    func testDeleteAllCompletedTasks() throws {
//        multipleTaskVM.deleteMultipleTasks { $0.isComplete }
//        
//        XCTAssertTrue(multipleTaskVM.tasks.allSatisfy { !$0.isComplete })
//    }
//    
//    func testDeleteMultipleTasks() throws {
//        multipleTaskVM.deleteMultipleTasks { $0.title == "laundry" }
//        
//        XCTAssertTrue(multipleTaskVM.tasks.allSatisfy { $0.title != "laundry" })
//    }
//    
//    func testDeleteTask() throws {
//        let previousTask = multipleTaskVM.tasks[6]
//        
//        multipleTaskVM.deleteTask(previousTask)
//        
//        XCTAssertTrue(multipleTaskVM.tasks.allSatisfy { $0.id != previousTask.id })
//    }
//    
    // TEST - Toggle done

    func testToggleDoneChangesTask() throws {
        let previousTask = multipleTaskVM.tasks[6]
        
        multipleTaskVM.toggleDone(previousTask)
        
        XCTAssertNotEqual(multipleTaskVM.tasks[6].isDone, previousTask.isDone)
    }

    // TEST - Add task
    
    func testAddTaskWithProperties() throws {
        let title = "task title"
        let details = "task details"
        let priority = 3
        
        simpleTaskVM.addTask(title: title, details: details, priority: priority)
        
        XCTAssertEqual(simpleTaskVM.tasks[0].title, title)
        XCTAssertEqual(simpleTaskVM.tasks[0].details, details)
        XCTAssertEqual(simpleTaskVM.tasks[0].priority, priority)
    }
    
    func testAddTaskPrepends() throws {
        let testTitle = "this is a test"
        
        multipleTaskVM.addTask(title: testTitle)
        
        XCTAssertEqual(multipleTaskVM.tasks[0].title, testTitle)
    }
    
    func testAddTask() throws {
        simpleTaskVM.addTask(title: "this is a test")
        
        XCTAssertEqual(simpleTaskVM.tasks.count, 1)
    }

    // TEST - Constructor
    
    func testMultipleTaskLists() throws {
        XCTAssertEqual(multipleTaskVM.taskLists.count, 4)
    }
    
    func testMultipleTasks() throws {
        XCTAssertEqual(multipleTaskVM.tasks.count, 16)
    }
    
    func testTaskListsIsNeverEmpty() throws {
        XCTAssertEqual(simpleTaskVM.taskLists[0].title, "My Tasks")
    }
    
    func testEmptyTasks() throws {
        XCTAssertTrue(simpleTaskVM.tasks.isEmpty)
    }
}
