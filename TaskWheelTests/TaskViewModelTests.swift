import XCTest
@testable import TaskWheel

final class TaskViewModelTests: XCTestCase {
    
    private var simpleTaskList: TaskViewModel!
    private var multipleTaskList: TaskViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        simpleTaskList = TaskViewModel()
        multipleTaskList = TaskViewModel(TaskModel.examples)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        simpleTaskList = nil
        multipleTaskList = nil
    }
    
    func testEmptyTaskList() throws {
        XCTAssertTrue(simpleTaskList.taskList.isEmpty)
    }
    
    func testAddTask() throws {
        simpleTaskList.addTask(title: "this is a test")
        
        XCTAssertEqual(simpleTaskList.taskList.count, 1)
    }
    
    func testAddTaskPrepends() throws {
        let testTitle = "this is a test"
        
        multipleTaskList.addTask(title: testTitle)
        
        XCTAssertEqual(multipleTaskList.taskList[0].title, testTitle)
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
