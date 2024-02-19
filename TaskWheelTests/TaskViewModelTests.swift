import XCTest
@testable import TaskWheel

final class TaskViewModelTests: XCTestCase {
    
    private var simpleTaskList: TaskViewModel!
    private var multipleTaskList: TaskViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        simpleTaskList = TaskViewModel()
        multipleTaskList = TaskViewModel(taskList: TaskModel.examples)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        simpleTaskList = nil
        multipleTaskList = nil
    }
    
    func testEmptyTaskList() throws {
        XCTAssertTrue(simpleTaskList.taskList.isEmpty)
    }
    
    func testAddValidTaskAddsTask() throws {
        let testTask = TaskModel(title: "this is a test")
        
        simpleTaskList.addTask(testTask)
        
        XCTAssertEqual(simpleTaskList.taskList.count, 1)
    }
    
    func testAddInvalidTaskDoesNothing() throws {
        let testTask = TaskModel(title: "")
        
        simpleTaskList.addTask(testTask)
        
        XCTAssertEqual(simpleTaskList.taskList.count, 0)
    }
        
    func testMultipleTaskList() throws {
        XCTAssertEqual(multipleTaskList.taskList.count, 25)
    }
    
    func testToggleCompleteChangesTask() throws {
        let recycleTask = multipleTaskList.taskList[6]
        
        multipleTaskList.toggleComplete(recycleTask)
        
        XCTAssertTrue(multipleTaskList.taskList[6].isComplete)
    }
}
