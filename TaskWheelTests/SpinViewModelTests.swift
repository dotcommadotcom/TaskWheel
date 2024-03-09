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
    
    // TEST - Urgency score
    
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
