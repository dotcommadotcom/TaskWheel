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
    
    // TEST - Update current title
    
    func testUpdateCurrentIsStillSame() throws {
        let previousID = multipleTaskVM.currentTaskList().id
        
        multipleTaskVM.updateCurrentTitle(to: "whats up")
        
        XCTAssertEqual(multipleTaskVM.currentTaskList().id, previousID)
    }
    
    func testUpdateCurrentTitle() throws {
        multipleTaskVM.updateCurrentTo(this: multipleTaskVM.taskLists[2])
        let previousTitle = multipleTaskVM.currentTitle()
        
        multipleTaskVM.updateCurrentTitle(to: "whats up")
        
        XCTAssertNotEqual(multipleTaskVM.currentTitle(), previousTitle)
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
    
    // TEST - Update task
    
    func testUpdateTaskDoesNotChangeOfTaskList() throws {
        let previousOfTaskList = multipleTaskVM.tasks[6].ofTaskList
        
        multipleTaskVM.update(this: multipleTaskVM.tasks[6], title: "new title", details: "lets add some more")
        
        XCTAssertEqual(multipleTaskVM.tasks[6].ofTaskList, previousOfTaskList)
    }
    
    func testUpdateMultipleProperties() throws {
        let previousTitle = multipleTaskVM.tasks[6].title
        let previousDetails = multipleTaskVM.tasks[6].details
        
        multipleTaskVM.update(this: multipleTaskVM.tasks[6], title: "new title", details: "lets add some more")
        
        XCTAssertNotEqual(multipleTaskVM.tasks[6].title, previousTitle)
        XCTAssertNotEqual(multipleTaskVM.tasks[6].details, previousDetails)
    }
    
    func testUpdateTaskWithNothingChangesNothing() throws {
        let noUpdates = multipleTaskVM.tasks[6]
        
        multipleTaskVM.update(this: noUpdates)
        
        XCTAssertEqual(multipleTaskVM.tasks[6], noUpdates)
    }
    
    func testUpdateTaskIsStillSameTask() throws {
        let targetTask = multipleTaskVM.tasks[6]
        
        multipleTaskVM.update(this: targetTask, priority: 2)
        
        XCTAssertEqual(multipleTaskVM.tasks[6].id, targetTask.id)
    }
    
    func testUpdateTask() throws {
        let previousPriority = multipleTaskVM.tasks[6].priority
        
        multipleTaskVM.update(this: multipleTaskVM.tasks[6], priority: 2)
        
        XCTAssertNotEqual(multipleTaskVM.tasks[6].priority, previousPriority)
    }
    
    // TEST - Delete task
    
    func testDeleteIfDone() throws {
        multipleTaskVM.deleteIf { $0.isDone }
        
        XCTAssertTrue(multipleTaskVM.tasks.allSatisfy { !$0.isDone })
    }
    
    func testDeleteIf() throws {
        multipleTaskVM.deleteIf { $0.title == "laundry" }
        
        XCTAssertTrue(multipleTaskVM.tasks.allSatisfy { $0.title != "laundry" })
    }
    
    func testDeleteTask() throws {
        let deleted = multipleTaskVM.tasks[6]
        
        multipleTaskVM.delete(this: deleted)
        
        XCTAssertTrue(multipleTaskVM.tasks.allSatisfy { $0.id != deleted.id })
    }
    
    // TEST - Toggle done

    func testToggleDoneChangesTask() throws {
        let notDone = multipleTaskVM.tasks[6]
        
        multipleTaskVM.toggleDone(notDone)
        
        XCTAssertNotEqual(multipleTaskVM.tasks[6].isDone, notDone.isDone)
    }

    // TEST - Add task
    
    func testAddTaskAddsToCurrent() throws {
        let currentID = multipleTaskVM.currentTaskList().id
        
        multipleTaskVM.addTaskList(title: "new task")
        
        XCTAssertEqual(multipleTaskVM.tasks[0].ofTaskList, currentID)
    }
    
    func testAddTaskWithProperties() throws {
        let title = "task title"
        let details = "task details"
        let priority = 2
        
        simpleTaskVM.addTask(title: title, details: details, priority: priority)
        
        XCTAssertEqual(simpleTaskVM.tasks[0].title, title)
        XCTAssertEqual(simpleTaskVM.tasks[0].details, details)
        XCTAssertEqual(simpleTaskVM.tasks[0].priority, priority)
    }
    
    func testAddEmptyTask() throws {
        simpleTaskVM.addTask()
        
        XCTAssertEqual(simpleTaskVM.tasks[0].title, "")
        XCTAssertEqual(simpleTaskVM.tasks[0].details, "")
        XCTAssertEqual(simpleTaskVM.tasks[0].priority, 1)
    }
    
    func testAddTaskPrepends() throws {
        let testTitle = "this is a test"
        
        multipleTaskVM.addTask(title: testTitle)
        
        XCTAssertEqual(multipleTaskVM.tasks[0].title, testTitle)
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
