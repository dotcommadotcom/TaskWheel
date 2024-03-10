import XCTest
@testable import TaskWheel

final class TaskVMTests: XCTestCase {
    
    private var simpleVM: TaskViewModel!
    private var multipleVM: TaskViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        simpleVM = TaskViewModel()
        multipleVM = TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        simpleVM = nil
        multipleVM = nil
    }
    
    // TEST - Update task
    
    func testUpdateTaskDoesNotChangeOfTaskList() throws {
        let previousOfTaskList = multipleVM.tasks[6].ofTaskList
        
        multipleVM.update(this: multipleVM.tasks[6], title: "new title", details: "lets add some more")
        
        XCTAssertEqual(multipleVM.tasks[6].ofTaskList, previousOfTaskList)
    }
    
    func testUpdateMultipleProperties() throws {
        let previousTitle = multipleVM.tasks[6].title
        let previousDetails = multipleVM.tasks[6].details
        
        multipleVM.update(this: multipleVM.tasks[6], title: "new title", details: "lets add some more")
        
        XCTAssertNotEqual(multipleVM.tasks[6].title, previousTitle)
        XCTAssertNotEqual(multipleVM.tasks[6].details, previousDetails)
    }
    
    func testUpdateTaskWithNothingChangesNothing() throws {
        let noUpdates = multipleVM.tasks[6]
        
        multipleVM.update(this: noUpdates)
        
        XCTAssertEqual(multipleVM.tasks[6], noUpdates)
    }
    
    func testUpdateTaskIsStillSameTask() throws {
        let targetTask = multipleVM.tasks[6]
        
        multipleVM.update(this: targetTask, priority: 2)
        
        XCTAssertEqual(multipleVM.tasks[6].id, targetTask.id)
    }
    
    func testUpdateTask() throws {
        let previousPriority = multipleVM.tasks[6].priority
        
        multipleVM.update(this: multipleVM.tasks[6], priority: 2)
        
        XCTAssertNotEqual(multipleVM.tasks[6].priority, previousPriority)
    }
    
    // TEST - Toggle done

    func testToggleDone() throws {
        let notDone = multipleVM.tasks[6]
        
        multipleVM.toggleDone(notDone)
        
        XCTAssertNotEqual(multipleVM.tasks[6].isDone, notDone.isDone)
    }
    
    // TEST - Delete task
    
    func testDeleteIfDone() throws {
        multipleVM.deleteIf { $0.isDone }
        
        XCTAssertTrue(multipleVM.tasks.allSatisfy { !$0.isDone })
    }
    
    func testDeleteIf() throws {
        multipleVM.deleteIf { $0.title == "laundry" }
        
        XCTAssertTrue(multipleVM.tasks.allSatisfy { $0.title != "laundry" })
    }
    
    func testDeleteTask() throws {
        let deleted = multipleVM.tasks[6]
        
        multipleVM.delete(this: deleted)
        
        XCTAssertTrue(multipleVM.tasks.allSatisfy { $0.id != deleted.id })
    }

    // TEST - Add task
    
    func testAddTaskAddsToCurrent() throws {
        let currentID = multipleVM.currentId()
        
        multipleVM.addTaskList(title: "new task")
        
        XCTAssertEqual(multipleVM.tasks[0].ofTaskList, currentID)
    }
    
    func testAddTaskWithProperties() throws {
        let title = "task title"
        let details = "task details"
        let priority = 2
        
        simpleVM.addTask(title: title, details: details, priority: priority)
        
        XCTAssertEqual(simpleVM.tasks[0].title, title)
        XCTAssertEqual(simpleVM.tasks[0].details, details)
        XCTAssertEqual(simpleVM.tasks[0].priority, priority)
    }
    
    func testAddEmptyTask() throws {
        simpleVM.addTask()
        
        XCTAssertEqual(simpleVM.tasks[0].title, "")
        XCTAssertEqual(simpleVM.tasks[0].details, "")
        XCTAssertEqual(simpleVM.tasks[0].priority, 3)
    }
    
    func testAddTaskPrepends() throws {
        let testTitle = "this is a test"
        
        multipleVM.addTask(title: testTitle)
        
        XCTAssertEqual(multipleVM.tasks[0].title, testTitle)
    }
    
    // TEST - Constructor
    
    func testMultipleTasks() throws {
        XCTAssertEqual(multipleVM.tasks.count, 16)
    }
    
    func testEmptyTasks() throws {
        XCTAssertTrue(simpleVM.tasks.isEmpty)
    }

}
