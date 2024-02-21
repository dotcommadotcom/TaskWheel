import XCTest
@testable import TaskWheel

final class TaskModelTests: XCTestCase {
    
    private var testTask: TaskModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        testTask = TaskModel(title: "this is a test")
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        testTask = nil
    }

    func testCanary() throws {
        XCTAssertTrue(true)
    }
    
    func testEditTitle() throws {
        testTask = testTask.editTitle("hello")
        
        XCTAssertEqual(testTask.title, "hello")
    }
    
    func testToggleCompleteTrue() throws {
        testTask = testTask.toggleComplete()
        
        XCTAssertTrue(testTask.isComplete)
    }

    func testToggleCompleteFalse() throws {
        testTask = testTask.toggleComplete()
        testTask = testTask.toggleComplete()
        
        XCTAssertFalse(testTask.isComplete)
    }
    
    func testToggleDeleteTrue() throws {
        testTask = testTask.markDeleted()
        testTask = testTask.markDeleted()
        
        XCTAssertTrue(testTask.isDeleted)
    }
}
