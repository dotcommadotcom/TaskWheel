import XCTest
@testable import TaskWheel

final class TaskVMTests: XCTestCase {
    
    private var simpleVM: TaskViewModel!
    private var multipleVM: TaskViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        simpleVM = TaskViewModel()
        multipleVM = TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        simpleVM = nil
        multipleVM = nil
    }
    
    // TEST - Change date
    
    func testChangeDateToTomorrow() throws {
        multipleVM.changeDate(of: multipleVM.tasks[6], to: fromNow(days: 1))
        
        XCTAssertEqual(multipleVM.tasks[6].date?.string(), fromNow(days: 1).string())
    }
    
    func testChangeDateToNil() throws {
        multipleVM.changeDate(of: multipleVM.tasks[6], to: nil)

        XCTAssertNil(multipleVM.tasks[6].date)
    }
    
    // TEST - Update task
    
//    func testUpdateTaskDateToNil() throws {
//        let previousDate = multipleVM.tasks[6].date
//        
//        multipleVM.update(this: multipleVM.tasks[6], date: nil)
//        
//        XCTAssertNil(multipleVM.tasks[6].date)
//    }
    
    func testUpdateMultipleProperties() throws {
        let previousTitle = multipleVM.tasks[6].title
        let previousOfTaskList = multipleVM.tasks[6].ofTaskList
        let previousDetails = multipleVM.tasks[6].details
        let previousPriority = multipleVM.tasks[6].priority
        let previousDate = multipleVM.tasks[6].date
        
        multipleVM.update(
            this: multipleVM.tasks[6],
            title: "new title",
            ofTaskList: multipleVM.currentId(),
            details: "lets add some more",
            priority: 0,
            date: fromNow(days: 1)
        )
        
        XCTAssertEqual(previousTitle, "its all a big circle jerk")
        XCTAssertNotEqual(multipleVM.tasks[6].title, previousTitle)
        XCTAssertNotEqual(multipleVM.tasks[6].ofTaskList, previousOfTaskList)
        XCTAssertNotEqual(multipleVM.tasks[6].details, previousDetails)
        XCTAssertNotEqual(multipleVM.tasks[6].priority, previousPriority)
        XCTAssertNotEqual(multipleVM.tasks[6].date?.string(), previousDate?.string())
    }
    
    func testUpdateTaskWithNothingChangesNothing() throws {
        let noUpdates = multipleVM.tasks[6]
        
        multipleVM.update(this: noUpdates)
        
        XCTAssertEqual(multipleVM.tasks[6], noUpdates)
    }
    
    func testUpdateTaskIsStillSameTask() throws {
        let targetTask = multipleVM.tasks[6]
        
        multipleVM.update(this: targetTask, priority: 0)
        
        XCTAssertEqual(multipleVM.tasks[6].id, targetTask.id)
    }
    
    func testUpdateTask() throws {
        let previousPriority = multipleVM.tasks[6].priority
        
        multipleVM.update(this: multipleVM.tasks[6], priority: 0)
        
        XCTAssertNotEqual(multipleVM.tasks[6].priority, previousPriority)
    }
    
    // TEST - Toggle done

    func testToggleDone() throws {
        let notDone = multipleVM.tasks[6]
        
        multipleVM.toggleDone(notDone)
        
        XCTAssertNotEqual(multipleVM.tasks[6].isDone, notDone.isDone)
    }
    
    // TEST - Delete task
    
    func testDeleteIfDone() throws {
        multipleVM.deleteIf { $0.isDone }
        
        XCTAssertTrue(multipleVM.tasks.allSatisfy { !$0.isDone })
    }
    
    func testDeleteIf() throws {
        multipleVM.deleteIf { $0.title == "laundry" }
        
        XCTAssertTrue(multipleVM.tasks.allSatisfy { $0.title != "laundry" })
    }
    
    func testDeleteTask() throws {
        let deleted = multipleVM.tasks[6]
        
        multipleVM.delete(this: deleted)
        
        XCTAssertTrue(multipleVM.tasks.allSatisfy { $0.id != deleted.id })
    }

    // TEST - Add task
    
    func testAddTaskAddsToCurrent() throws {
        multipleVM.addTask(title: "new task")
        
        XCTAssertEqual(multipleVM.tasks[0].title, "new task")
        XCTAssertEqual(multipleVM.tasks[0].ofTaskList, multipleVM.currentId())
    }
    
    func testAddTaskWithProperties() throws {
        let title = "task title"
        let details = "task details"
        let priority = 2
        let date = fromNow(days: 14)
        
        simpleVM.addTask(title: title, details: details, priority: priority, date: date)
        
        XCTAssertEqual(simpleVM.tasks[0].title, title)
        XCTAssertEqual(simpleVM.tasks[0].details, details)
        XCTAssertEqual(simpleVM.tasks[0].priority, priority)
        XCTAssertEqual(simpleVM.tasks[0].date?.string(), date.string())
    }
    
    func testAddEmptyTask() throws {
        simpleVM.addTask()
        
        XCTAssertEqual(simpleVM.tasks[0].title, "")
        XCTAssertFalse(simpleVM.tasks[0].isDone)
        XCTAssertEqual(simpleVM.tasks[0].details, "")
        XCTAssertEqual(simpleVM.tasks[0].priority, 3)
        XCTAssertNil(simpleVM.tasks[0].date)
    }
    
    func testAddTaskPrepends() throws {
        let testTitle = "this is a test"
        
        multipleVM.addTask(title: testTitle)
        
        XCTAssertEqual(multipleVM.tasks[0].title, testTitle)
    }
    
    // TEST - Constructor
    
    func testMultipleTasks() throws {
        XCTAssertEqual(multipleVM.tasks.count, 16)
    }
    
    func testEmptyTasks() throws {
        XCTAssertTrue(simpleVM.tasks.isEmpty)
    }

}
