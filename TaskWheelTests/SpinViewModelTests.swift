import XCTest
@testable import TaskWheel

final class SpinViewModelTests: XCTestCase {
    
    private var taskVM: TaskViewModel!
    private var spinVM: SpinViewModel!
    private var calendar: Calendar!
    private var today: Date!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        taskVM = TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples)
        spinVM = SpinViewModel()
        calendar = Calendar.current
        today = Date()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        taskVM = nil
        spinVM = nil
        calendar = nil
        today = nil
    }
    
    // TEST - Weights of task with due dates
    
    func testWeightOfFutureDates() throws {
        let high = TaskModel(title: "", priority: 0, date: fromNow(days: 7))
        let medium = TaskModel(title: "", priority: 1, date: fromNow(days: 7))
        let low = TaskModel(title: "", priority: 2, date: fromNow(days: 7))
        let none = TaskModel(title: "", priority: 3, date: fromNow(days: 7))
        
        XCTAssertEqual(spinVM.scoreUrgency(of: high) + spinVM.scoreImportance(of: high), 10.978)
        XCTAssertEqual(spinVM.scoreUrgency(of: medium) + spinVM.scoreImportance(of: medium), 7.978)
        XCTAssertEqual(spinVM.scoreUrgency(of: low) + spinVM.scoreImportance(of: low), 4.978)
        XCTAssertEqual(spinVM.scoreUrgency(of: none) + spinVM.scoreImportance(of: none), 1.978)
    }
    
    // TEST - Weights of task created today
    
    func testWeightOfTasksCreatedToday() throws {
        let basic = TaskModel(title: "i'm basic")
        let onlyImportant = TaskModel(title: "i'm important", priority: 0)
        let onlyUrgent = TaskModel(title: "i'm urgent", date: Date())
        let both = TaskModel(title: "i'm important and urgent", priority: 0, date: Date())
        
        
        XCTAssertEqual(spinVM.scoreUrgency(of: basic) + spinVM.scoreImportance(of: basic), -10.0)
        XCTAssertEqual(spinVM.scoreUrgency(of: onlyImportant) + spinVM.scoreImportance(of: onlyImportant), -1.0)
        XCTAssertEqual(spinVM.scoreUrgency(of: onlyUrgent) + spinVM.scoreImportance(of: onlyUrgent), 5.0)
        XCTAssertEqual(spinVM.scoreUrgency(of: both) + spinVM.scoreImportance(of: both), 14.0)
    }

    // TEST - Urgency score of due date
    
    func testDueThreeWeeksUrgency() throws {
        let task = taskVM.tasks[14]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 0.392)
    }
    
    func testDueThreeDaysUrgency() throws {
        let task = taskVM.tasks[11]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 3.543)
    }
    
    func testDueTodayUrgency() throws {
        let task = taskVM.tasks[8]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 5.0)
    }
    
    func testDueYesterdayUrgency() throws {
        let task = taskVM.tasks[3]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 5.498)
    }
    
    func testDueTwoWeeksAgoUrgency() throws {
        let task = taskVM.tasks[0]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 9.427)
    }
    
    func testTasksDueDate() throws {
        let dueDate = taskVM.tasks.enumerated().filter { index, task in
            task.ofTaskList == taskVM.currentId() && !task.isDone && task.date != nil
        }.map { $0.offset }
        
        XCTAssertEqual(dueDate, [0, 3, 8, 11, 14])
    }
    
    // TEST - Urgency score of creation dates
    
    func testCreatedOneYear() throws {
        let task = taskVM.tasks[10]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 9.105)
    }
    
    func testCreatedTwoMonths() throws {
        let task = taskVM.tasks[9]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), -2.789)
    }
    
    func testCreatedTwoDaysAgoUrgency() throws {
        let task = taskVM.tasks[7]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), -8.586)
    }
    
    func testCreatedTodayUrgency() throws {
        let task = taskVM.tasks[2]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), -10.0)
    }
    
    func testTasksNoDueDate() throws {
        let noDueDate = taskVM.tasks.enumerated().filter { index, task in
            task.ofTaskList == taskVM.currentId() && !task.isDone && task.date == nil
        }.map { $0.offset }
        
        XCTAssertEqual(noDueDate, [2, 7, 9, 10])
    }
    
    // TEST - find tasks to test
    
    func testTasksNotCurrent() throws {
        let notCurrent = taskVM.tasks.enumerated().filter { index, task in
            task.ofTaskList != taskVM.currentId()
        }.map { $0.offset }
        
        XCTAssertEqual(notCurrent, [1, 4, 6, 12, 15])
    }
    
    func testTasksDoneDate() throws {
        let done = taskVM.tasks.enumerated().filter { index, task in
            task.ofTaskList == taskVM.currentId() && task.isDone
        }.map { $0.offset }
        
        XCTAssertEqual(done, [5, 13])
    }
    
    // TEST - Importance score
    
    func testImportanceOfNone() throws {
        let task = TaskModel(title: "none")
        
        XCTAssertEqual(spinVM.scoreImportance(of: task), 0)
    }
    
    func testImportanceOfLow() throws {
        let task = TaskModel(title: "low", priority: 2)
        
        XCTAssertEqual(spinVM.scoreImportance(of: task), 3)
    }
    
    func testImportanceOfMedium() throws {
        let task = TaskModel(title: "medium", priority: 1)
        
        XCTAssertEqual(spinVM.scoreImportance(of: task), 6)
    }
    
    func testImportanceOfHigh() throws {
        let task = TaskModel(title: "high", priority: 0)
        
        XCTAssertEqual(spinVM.scoreImportance(of: task), 9)
    }
    
    // TEST - Constructor
    
    func testSelectdIndexIsNil() throws {
        XCTAssertNil(spinVM.selectedIndex)
    }
}
