import XCTest
@testable import TaskWheel

final class TaskVMListTests: XCTestCase {
    
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
    
    // TEST - Current task list
    
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
