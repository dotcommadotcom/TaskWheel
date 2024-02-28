import XCTest
@testable import TaskWheel

final class TaskViewModelTests: XCTestCase {
    
    private var simpleTaskVM: TaskViewModel!
    private var multipleTaskVM: TaskViewModel!
    private var sampleTask: TaskModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        simpleTaskVM = TaskViewModel()
        multipleTaskVM = TaskViewModel(TaskModel.examples, TaskListModel.examples)
        sampleTask = multipleTaskVM.tasks[6]
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        simpleTaskVM = nil
        multipleTaskVM = nil
        sampleTask = nil
    }
    
    // TEST - Update task
    
    func testUpdateTaskDoesNotChangeID() throws {
        let previousId = sampleTask.id
        
        multipleTaskVM.update(task: sampleTask, priority: 2)
        
        XCTAssertEqual(multipleTaskVM.tasks[6].id, previousId)
    }
    
    func testUpdateMultiple() throws {
        let previousTitle = sampleTask.title
        let previousDetails = sampleTask.details
        
        multipleTaskVM.update(task: sampleTask, title: "new title", details: "lets add some more")
        
        XCTAssertNotEqual(multipleTaskVM.tasks[6].title, previousTitle)
        XCTAssertNotEqual(multipleTaskVM.tasks[6].details, previousDetails)
    }
    
    func testUpdateTask() throws {
        let previousPriority = sampleTask.priority
        
        multipleTaskVM.update(task: sampleTask, priority: 2)
        
        XCTAssertNotEqual(multipleTaskVM.tasks[6].priority, previousPriority)
    }
    

    
    // TEST - Toggle complete

    func testToggleCompleteChangesTask() throws {
        multipleTaskVM.toggleComplete(task: sampleTask)
        
        XCTAssertTrue(multipleTaskVM.tasks[6].isComplete)
    }
    
    // TEST - Delete task
    
    func testDeleteTask() throws {
        multipleTaskVM.delete(task: sampleTask)
        
        XCTAssertEqual(multipleTaskVM.tasks.count, 24)
    }

    // TEST - Add task
    
    func testAddTaskWithProperties() throws {
        let title = "task title"
        let details = "task details"
        let priority = 3
        
        simpleTaskVM.add(title: title, details: details, priority: priority)
        
        XCTAssertEqual(simpleTaskVM.tasks[0].title, title)
        XCTAssertEqual(simpleTaskVM.tasks[0].details, details)
        XCTAssertEqual(simpleTaskVM.tasks[0].priority, priority)
    }
    
    func testAddTaskPrepends() throws {
        let testTitle = "this is a test"
        
        multipleTaskVM.add(title: testTitle)
        
        XCTAssertEqual(multipleTaskVM.tasks[0].title, testTitle)
    }
    
    func testAddTask() throws {
        simpleTaskVM.add(title: "this is a test")
        
        XCTAssertEqual(simpleTaskVM.tasks.count, 1)
    }

    // TEST - Constructor
    
    func testMultipleTaskLists() throws {
        XCTAssertEqual(multipleTaskVM.taskLists.count, 4)
    }
    
    func testMultipleTasks() throws {
        XCTAssertEqual(multipleTaskVM.tasks.count, 25)
    }
    
    func testTaskListsDefaultIsMyTasks() throws {
        XCTAssertEqual(simpleTaskVM.taskLists[0], simpleTaskVM.defaultTaskList)
    }
    
    func testTaskListsIsNeverEmpty() throws {
        XCTAssertEqual(simpleTaskVM.taskLists[0].title, "My Tasks")
    }
    
    func testEmptyTasks() throws {
        XCTAssertTrue(simpleTaskVM.tasks.isEmpty)
    }
}
