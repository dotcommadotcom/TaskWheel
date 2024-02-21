import XCTest
@testable import TaskWheel

final class TaskViewModelTests: XCTestCase {
    
    private var simpleTaskVM: TaskViewModel!
    private var multipleTaskVM: TaskViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        simpleTaskVM = TaskViewModel()
        multipleTaskVM = TaskViewModel(TaskModel.examples)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        simpleTaskVM = nil
        multipleTaskVM = nil
    }
    
    func testEmptyTaskList() throws {
        XCTAssertTrue(simpleTaskVM.taskList.isEmpty)
    }
    
    func testAddTask() throws {
        simpleTaskVM.addTask(title: "this is a test")
        
        XCTAssertEqual(simpleTaskVM.taskList.count, 1)
    }
    
    func testAddTaskPrepends() throws {
        let testTitle = "this is a test"
        
        multipleTaskVM.addTask(title: testTitle)
        
        XCTAssertEqual(multipleTaskVM.taskList[0].title, testTitle)
    }
    
    func testMultipleTaskList() throws {
        XCTAssertEqual(multipleTaskVM.taskList.count, 25)
    }
    
    func testToggleCompleteChangesTask() throws {
        let recycleTask = multipleTaskVM.taskList[6]
        
        multipleTaskVM.toggleComplete(recycleTask)
        
        XCTAssertTrue(multipleTaskVM.taskList[6].isComplete)
    }
    
    func testDeleteTask() throws {
        let recycleTask = multipleTaskVM.taskList[6]
        
        multipleTaskVM.deleteTask(recycleTask)
        
        XCTAssertTrue(multipleTaskVM.taskList[6].isDeleted)
    }
    
    func testShowTasks() throws {
        let recycleTask = multipleTaskVM.taskList[6]
        multipleTaskVM.deleteTask(recycleTask)
        
        let updatedTaskList = multipleTaskVM.showTasks()
        
        XCTAssertFalse(updatedTaskList.contains(recycleTask))
    }
}
