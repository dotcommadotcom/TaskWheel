import XCTest
@testable import TaskWheel

final class SpinViewModelTests: XCTestCase {
    
    private var taskVM: TaskViewModel!
    private var spinVM: SpinViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        taskVM = TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples)
        spinVM = SpinViewModel(taskVM: taskVM)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        taskVM = nil
        spinVM = nil
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
    
    func testTasksCountEqualWeightsCount() throws {
        let tasksCount = taskVM.currentTasks().count
        
        XCTAssertEqual(spinVM.weights.count, tasksCount)
    }
    
    func testSelectdTaskIsNil() throws {
        XCTAssertNil(spinVM.selectedTask)
    }
}
