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
    
    func testAddTaskPrepends() throws {
        let testTitle = "this is a test"
        
        multipleTaskVM.add(title: testTitle)
        
        XCTAssertEqual(multipleTaskVM.taskList[0].title, testTitle)
    }
    
    // TEST - Toggle complete

    func testToggleCompleteChangesTask() throws {
        let recycleTask = multipleTaskVM.taskList[6]
        
        multipleTaskVM.toggleComplete(task: recycleTask)
        
        XCTAssertTrue(multipleTaskVM.taskList[6].isComplete)
    }
    
    // TEST - Delete task
    
    func testDeleteTask() throws {
        let recycleTask = multipleTaskVM.taskList[6]
        
        multipleTaskVM.delete(task: recycleTask)
        
        XCTAssertNotEqual(multipleTaskVM.taskList[6], recycleTask)
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
