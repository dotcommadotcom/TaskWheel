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
    
    // TEST - Order
    
    func testEditOrder() throws {
        testTaskList = testTaskList.edit(order: .priority)
        
        XCTAssertEqual(testTaskList.order, .priority)
    }
    
    // TEST - Count
    
    func testDecrementCount() throws {
        testTaskList = testTaskList.decrementCount()
        
        XCTAssertEqual(testTaskList.count, -1)
    }
    
    func testIncrementCount() throws {
        testTaskList = testTaskList.incrementCount()
        
        XCTAssertEqual(testTaskList.count, 1)
    }
    
    // TEST - isDoneVisible
    
    func testToggleDoneVisibleTrue() throws {
        testTaskList = testTaskList.toggleDoneVisible()
        testTaskList = testTaskList.toggleDoneVisible()
        
        XCTAssertTrue(testTaskList.isDoneVisible)
    }
    
    func testToggleDoneVisibleFalse() throws {
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
        let previousCount = testTaskList.count
        let previousOrder = testTaskList.order
        
        testTaskList = testTaskList.edit(title: "new title", isDoneVisible: false, count: 3, order: .date)
        
        XCTAssertNotEqual(testTaskList.title, previousTitle)
        XCTAssertNotEqual(testTaskList.isDoneVisible, previousIsDoneVisible)
        XCTAssertNotEqual(testTaskList.count, previousCount)
        XCTAssertNotEqual(testTaskList.order, previousOrder)
    }
    
    func testEmptyEditHelperDoesNothing() throws {
        XCTAssertEqual(testTaskList.edit(), testTaskList)
    }
    
    func testEditHelperDoesNotChangeId() throws {
        let previousID = testTaskList.id
        
        testTaskList = testTaskList.edit(title: "new task list title")
        
        XCTAssertEqual(testTaskList.id, previousID)
    }
}
