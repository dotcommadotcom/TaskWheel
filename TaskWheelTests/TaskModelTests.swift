import XCTest
@testable import TaskWheel

final class TaskModelTests: XCTestCase {
    
    private var testTask: TaskModel!
    private var testTaskList: TaskListModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        testTaskList = TaskListModel(title: "sample task list")
        testTask = TaskModel(title: "this is a test",
                             ofTaskList: testTaskList.id,
                             details: "details test")
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        testTask = nil
        testTaskList = nil
    }
    
    func testCanary() throws {
        XCTAssertTrue(true)
    }
    
    // TEST - Move task list
    
    func testEditOfTaskList() throws {
        let newTaskList = TaskListModel(title: "new task list")
        
        let testTask = testTask.edit(ofTaskList: newTaskList.id)
        
        XCTAssertNotEqual(testTask.ofTaskList, testTaskList.id)
    }
    
    // TEST - Priority
    
    func testEditPriority() throws {
        let testTask = testTask.edit(priority: 1)
        
        XCTAssertEqual(testTask.priority, 1)
    }
    
    // TEST - Details
    
    func testEditDetails() throws {
        testTask = testTask.edit(details: "new details")
        
        XCTAssertEqual(testTask.details, "new details")
    }
    
    // TEST - isDone
    
    func testToggleDoneFalse() throws {
        testTask = testTask.toggleDone()
        testTask = testTask.toggleDone()
        
        XCTAssertFalse(testTask.isDone)
    }
    
    func testToggleDoneTrue() throws {
        testTask = testTask.toggleDone()
        
        XCTAssertTrue(testTask.isDone)
    }
    
    // TEST - Title
    
    func testEditTitle() throws {
        testTask = testTask.edit(title: "hello")
        
        XCTAssertEqual(testTask.title, "hello")
    }
    
    // TEST - Edit Helper
    
    func testEmptyEditHelper() throws {
        XCTAssertEqual(testTask.edit(), testTask)
    }
    
    func testEditHelperDoesNotChangeTaskList() throws {
        let previousOfTaskList = testTask.ofTaskList
        
        testTask = testTask.edit(title: "new title")
        
        XCTAssertEqual(testTask.ofTaskList, previousOfTaskList)
    }
    
    func testEditHelperDoesNotChangeId() throws {
        let previousID = testTask.id
        
        testTask = testTask.edit(title: "new title")
        
        XCTAssertEqual(testTask.id, previousID)
    }
    
    // TEST - Constructor
    
    func testConstructorIdIsNotOfTaskList() throws {
        let sampleTask = TaskModel(title: "test id")
        
        XCTAssertNotEqual(sampleTask.id, sampleTask.ofTaskList)
    }
}
