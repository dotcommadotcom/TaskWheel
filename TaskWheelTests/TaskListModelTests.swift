import XCTest
@testable import TaskWheel

final class TaskListModelTests: XCTestCase {
    
    private var testTaskList: TaskListModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        testTaskList = TaskListModel(title: "sample task list")
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        testTaskList = nil
    }
    
    // TEST - Title
    
    func testEditTitle() throws {
        testTaskList = testTaskList.edit(title: "hello")
        
        XCTAssertEqual(testTaskList.title, "hello")
    }

    // TEST - Edit Helper
    
    func testEmptyEditHelper() throws {
        XCTAssertEqual(testTaskList.edit(), testTaskList)
    }
    
    func testEditHelperDoesNotChangeId() throws {
        let previousID = testTaskList.id
        
        testTaskList = testTaskList.edit(title: "new task list title")
        
        XCTAssertEqual(testTaskList.id, previousID)
    }
}
