import XCTest
@testable import TaskWheel

final class TaskModelTests: XCTestCase {
    
    private var testTask: TaskModel!
    private var testTaskList: TaskListModel!
    let dateFormatter = DateFormatter()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        testTaskList = TaskListModel(title: "sample task list")
        testTask = TaskModel(title: "this is a test",
                             ofTaskList: testTaskList.id,
                             details: "details test",
                             date: Date())
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        testTask = nil
        testTaskList = nil
    }
    
    func testCanary() throws {
        XCTAssertTrue(true)
    }
    
    // TEST - Change date
    
    func testChangeDateToTomorrow() throws {
        let tomorrow = fromNow(days: 1)
        
        testTask = testTask.changeDate(to: fromNow(days: 1))
        
        XCTAssertEqual(testTask.date?.string(), tomorrow.string())
    }

    func testChangeDateToNil() throws {
        testTask = testTask.changeDate(to: nil)
        
        XCTAssertNil(testTask.date)
    }
    
    // TEST - Move task list
    
    func testEditOfTaskList() throws {
        let newTaskList = TaskListModel(title: "new task list")
        
        testTask = testTask.edit(ofTaskList: newTaskList.id)
        
        XCTAssertNotEqual(testTask.ofTaskList, testTaskList.id)
    }
    
    // TEST - Priority
    
    func testEditPriority() throws {
        testTask = testTask.edit(priority: 1)
        
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
        let empty = testTask.edit()
        
        XCTAssertEqual(empty, testTask)
        XCTAssertEqual(empty.title, testTask.title)
        XCTAssertEqual(empty.ofTaskList, testTask.ofTaskList)
        XCTAssertEqual(empty.isDone, testTask.isDone)
        XCTAssertEqual(empty.details, testTask.details)
        XCTAssertEqual(empty.priority, testTask.priority)
        XCTAssertEqual(empty.date?.string(), testTask.date?.string())
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
    
    func testCreationDateIsYesterday() throws {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        let sampleTask = TaskModel(creation: yesterday, title: "test id")
        
        XCTAssertEqual(sampleTask.creation.string(), yesterday.string())
    }
    
    func testCreationDateIsToday() throws {
        let sampleTask = TaskModel(title: "test id")
        
        XCTAssertEqual(sampleTask.creation.string(), Date().string())
    }
    
    func testConstructorIdIsNotEqualToTaskListId() throws {
        let sampleTask = TaskModel(title: "test id")
        
        XCTAssertNotEqual(sampleTask.id, sampleTask.ofTaskList)
    }
    
    func testConstructor() throws {
        let sampleTask = TaskModel(title: "")
        
        XCTAssertNotNil(sampleTask.id)
        XCTAssertNotNil(sampleTask.creation)
        XCTAssertNotNil(sampleTask.ofTaskList)
        XCTAssertFalse(sampleTask.isDone)
        XCTAssertEqual(sampleTask.details, "")
        XCTAssertEqual(sampleTask.priority, 3)
        XCTAssertNil(sampleTask.date)
    }
}
