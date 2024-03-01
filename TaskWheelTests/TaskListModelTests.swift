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
    
    // TEST - isComplete
    
    func testToggleCompleteFalse() throws {
        testTaskList = testTaskList.toggleDoneVisible()
        testTaskList = testTaskList.toggleDoneVisible()
        
        XCTAssertTrue(testTaskList.isDoneVisible)
    }
    
    func testToggleCompleteTrue() throws {
        testTaskList = testTaskList.toggleDoneVisible()
        
        XCTAssertFalse(testTaskList.isDoneVisible)
    }
    
    // TEST - Title
    
    func testEditTitle() throws {
        testTaskList = testTaskList.edit(title: "hello")
        
        XCTAssertEqual(testTaskList.title, "hello")
    }

    // TEST - Edit Helper
    
    func testEditMultipleAttributes() throws {
        let previousTitle = testTaskList.title
        let previousIsDoneVisible = testTaskList.isDoneVisible
        
        testTaskList = testTaskList.edit(title: "new title", isDoneVisible: false)
        
        XCTAssertNotEqual(testTaskList.title, previousTitle)
        XCTAssertNotEqual(testTaskList.isDoneVisible, previousIsDoneVisible)
    }
    
    func testEmptyEditHelper() throws {
        XCTAssertEqual(testTaskList.edit(), testTaskList)
    }
    
    func testEditHelperDoesNotChangeId() throws {
        let previousID = testTaskList.id
        
        testTaskList = testTaskList.edit(title: "new task list title")
        
        XCTAssertEqual(testTaskList.id, previousID)
    }
}
