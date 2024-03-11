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
        spinVM = SpinViewModel(taskVM: taskVM)
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
    
    // TEST - Weights
    
    //    func testWeights() throws {
    //        XCTAssertEqual(spinVM.weights(), [])
    //    }
    
    
    
    
    
    // TEST - Urgency score of due date
    
    func testUrgencyOfYesterday() throws {
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let task = TaskModel(title: "", date: yesterday)
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 0.1)
    }
    
    func testUrgencyOfTomorrow() throws {
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let task = TaskModel(title: "", date: tomorrow)
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), -0.1)
    }
    
    func testUrgencyOfToday() throws {
        let task = TaskModel(title: "", date: today)
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 0)
    }
    
    func testUrgencyOfCreatedToday() throws {
        let task = TaskModel(title: "")
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 0)
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
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 9.104, accuracy: 0.001)
    }
    
    func testCreatedTwoMonths() throws {
        let task = taskVM.tasks[9]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), -2.788, accuracy: 0.001)
    }
    
    func testCreatedTwoDaysAgoUrgency() throws {
        let task = taskVM.tasks[7]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), -8.585, accuracy: 0.001)
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
        
        XCTAssertEqual(spinVM.scoreImportance(of: task), 1)
    }
    
    func testImportanceOfLow() throws {
        let task = TaskModel(title: "low", priority: 2)
        
        XCTAssertEqual(spinVM.scoreImportance(of: task), 2)
    }
    
    func testImportanceOfMedium() throws {
        let task = TaskModel(title: "medium", priority: 1)
        
        XCTAssertEqual(spinVM.scoreImportance(of: task), 3)
    }
    
    func testImportanceOfHigh() throws {
        let task = TaskModel(title: "high", priority: 0)
        
        XCTAssertEqual(spinVM.scoreImportance(of: task), 4)
    }
    
    // TEST - Constructor
    
    func testSelectdIndexIsNil() throws {
        XCTAssertNil(spinVM.selectedIndex)
    }
}
