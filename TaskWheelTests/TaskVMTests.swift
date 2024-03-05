import XCTest
@testable import TaskWheel

final class TaskVMTests: XCTestCase {
    
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
        XCTAssertEqual(simpleTaskVM.tasks[0].priority, 3)
    }
    
    func testAddTaskPrepends() throws {
        let testTitle = "this is a test"
        
        multipleTaskVM.addTask(title: testTitle)
        
        XCTAssertEqual(multipleTaskVM.tasks[0].title, testTitle)
    }
    
    // TEST - Constructor
    
    func testMultipleTasks() throws {
        XCTAssertEqual(multipleTaskVM.tasks.count, 16)
    }
    
    func testEmptyTasks() throws {
        XCTAssertTrue(simpleTaskVM.tasks.isEmpty)
    }

}
