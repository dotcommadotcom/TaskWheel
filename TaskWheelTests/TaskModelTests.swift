import XCTest
@testable import TaskWheel

final class TaskModelTests: XCTestCase {
    
    private var testTask: TaskModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        testTask = TaskModel(title: "this is a test",
                             details: "details test")
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        testTask = nil
    }
    
    func testCanary() throws {
        XCTAssertTrue(true)
    }
    
    // TEST - Edit Helper
    
    func testEditHelperDoesNotChangeId() throws {
        let previousID = testTask.id
        
        testTask = testTask.editTitle("new title")
        
        XCTAssertEqual(testTask.id, previousID)
    }
    
    func testEmptyEditHelper() throws {
        XCTAssertEqual(testTask.edit(), testTask)
    }
    
    // TEST - Title
    
    func testEditTitle() throws {
        testTask = testTask.editTitle("hello")
        
        XCTAssertEqual(testTask.title, "hello")
    }
    
    // TEST - isComplete

    
    func testToggleCompleteTrue() throws {
        testTask = testTask.toggleComplete()
        
        XCTAssertTrue(testTask.isComplete)
    }
    
    func testToggleCompleteFalse() throws {
        testTask = testTask.toggleComplete()
        testTask = testTask.toggleComplete()
        
        XCTAssertFalse(testTask.isComplete)
    }
    
    // TEST - Details
    
    func testEditDetails() throws {
        testTask = testTask.editDetails("new details")
        
        XCTAssertEqual(testTask.details, "new details")
    }
    
    // TEST - Priority
    
    func testEditPriority() throws {
        let testTask = testTask.editPriority(1)
        
        XCTAssertEqual(testTask.priority, 1)
    }
}
