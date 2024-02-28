import XCTest
@testable import TaskWheel

final class TaskViewModelTests: XCTestCase {
    
    private var simpleTaskVM: TaskViewModel!
    private var multipleTaskVM: TaskViewModel!
    private var sampleTask: TaskModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        simpleTaskVM = TaskViewModel()
        multipleTaskVM = TaskViewModel(TaskModel.examples)
        sampleTask = multipleTaskVM.taskList[6]
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        simpleTaskVM = nil
        multipleTaskVM = nil
        sampleTask = nil
    }
    
    // TEST - Constructor
    
    func testEmptyTaskList() throws {
        XCTAssertTrue(simpleTaskVM.taskList.isEmpty)
    }
    
    func testMultipleTaskList() throws {
        XCTAssertEqual(multipleTaskVM.taskList.count, 25)
    }
    
    // TEST - Add task
    
    func testAddTask() throws {
        simpleTaskVM.add(title: "this is a test")
        
        XCTAssertEqual(simpleTaskVM.taskList.count, 1)
    }
    
    func testAddTaskWithProperties() throws {
        let title = "task title"
        let details = "task details"
        let priority = 3
        
        simpleTaskVM.add(title: title, details: details, priority: priority)
        
        XCTAssertEqual(simpleTaskVM.taskList[0].title, title)
        XCTAssertEqual(simpleTaskVM.taskList[0].details, details)
        XCTAssertEqual(simpleTaskVM.taskList[0].priority, priority)
    }
    
    func testAddTaskPrepends() throws {
        let testTitle = "this is a test"
        
        multipleTaskVM.add(title: testTitle)
        
        XCTAssertEqual(multipleTaskVM.taskList[0].title, testTitle)
    }
    
    // TEST - Toggle complete

    func testToggleCompleteChangesTask() throws {
        multipleTaskVM.toggleComplete(task: sampleTask)
        
        XCTAssertTrue(multipleTaskVM.taskList[6].isComplete)
    }
    
    // TEST - Delete task
    
    func testDeleteTask() throws {
        multipleTaskVM.delete(task: sampleTask)
        
        XCTAssertEqual(multipleTaskVM.taskList.count, 24)
    }
    
    // TEST - Update task
    
    func testUpdateTask() throws {
        let previousPriority = sampleTask.priority
        
        multipleTaskVM.update(task: sampleTask, priority: 2)
        
        XCTAssertNotEqual(multipleTaskVM.taskList[6].priority, previousPriority)
    }
    
    func testUpdateMultiple() throws {
        let previousTitle = sampleTask.title
        let previousDetails = sampleTask.details
        
        multipleTaskVM.update(task: sampleTask, title: "new title", details: "lets add some more")
        
        XCTAssertNotEqual(multipleTaskVM.taskList[6].title, previousTitle)
        XCTAssertNotEqual(multipleTaskVM.taskList[6].details, previousDetails)
    }
    
    func testUpdateTaskDoesNotChangeID() throws {
        let previousId = sampleTask.id
        
        multipleTaskVM.update(task: sampleTask, priority: 2)
        
        XCTAssertEqual(multipleTaskVM.taskList[6].id, previousId)
    }
    
//    func testShowTasks() throws {
//        let recycleTask = multipleTaskVM.taskList[6]
//        multipleTaskVM.deleteTask(recycleTask)
//        
//        let updatedTaskList = multipleTaskVM.showTasks()
//        
//        XCTAssertFalse(updatedTaskList.contains(recycleTask))
//    }
}
