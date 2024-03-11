import XCTest
@testable import TaskWheel
import DequeModule

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
    
    // TEST - Select random index
    
    func testSelectRandomIndexForTwoTasks() throws {
        let tasks = Deque([TaskModel(title: "i'm not alone"),
                           TaskModel(title: "i'm here too")])
        
        XCTAssertTrue((0...1).contains(spinVM.selectRandomIndex(from: tasks)))
    }
    
    func testSelectRandomIndexForSingle() throws {
        let tasks = Deque([TaskModel(title: "i'm alone")])
        
        XCTAssertEqual(spinVM.selectRandomIndex(from: tasks), 0)
    }
    
    func testSelectRandomIndexForEmpty() throws {
        XCTAssertEqual(spinVM.selectRandomIndex(from: Deque()), -1)
    }

    // TEST - Weights
    
    func testTotalWeightsForSameScoreTasksIsNeverZero() throws {
        let task1 = TaskModel(title: "i'm not alone")
        let task2 = TaskModel(title: "i'm here")

        let score1 = spinVM.score(of: task1)
        let score2 = spinVM.score(of: task2)
        let weights = spinVM.weights(from: Deque([task1, task2]))
        
        XCTAssertTrue(score1 == score2 && weights.reduce(0, +) > 0)
    }
    
    func testTotalWeights() throws {
        let weights = spinVM.weights(from: taskVM.currentTasks())
        
        XCTAssertEqual(weights.reduce(0, +), 91.873, accuracy: 0.001)
    }
    
    func testWeightsForSingleTask() throws {
        let tasks = Deque([TaskModel(title: "i'm alone")])
        let weights = spinVM.weights(from: tasks)
        
        XCTAssertEqual(weights, [0.001])
    }
    
    func testWeightsAreAllPositive() throws {
        let weights = spinVM.weights(from: taskVM.currentTasks())
        
        XCTAssertTrue(weights.allSatisfy { $0 >= 0 })
    }
    
    func testWeightsCount() throws {
        let weights = spinVM.weights(from: taskVM.currentTasks())
        
        XCTAssertEqual(weights.count, taskVM.currentCount())
    }
    
    func testWeights() throws {
        let weights = spinVM.weights(from: taskVM.currentTasks())
        
        XCTAssertEqual(weights, [15.014, 4.587, 17.085, 0.001, 19.587, 2.798, 14.692, 9.13, 8.979])
    }
    
    // TEST - Score total
    
    func testScore() throws {
        let task = taskVM.tasks[14]
        
        XCTAssertEqual(spinVM.score(of: task), 3.392)
    }

    // TEST - Urgency score of due date
    
    func testDueThreeWeeksUrgency() throws {
        let task = taskVM.tasks[14]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 0.392, accuracy: 0.001)
    }
    
    func testDueThreeDaysUrgency() throws {
        let task = taskVM.tasks[11]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 3.543, accuracy: 0.001)
    }
    
    func testDueTodayUrgency() throws {
        let task = taskVM.tasks[8]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 5.0, accuracy: 0.001)
    }
    
    func testDueYesterdayUrgency() throws {
        let task = taskVM.tasks[3]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 5.498, accuracy: 0.001)
    }
    
    func testDueTwoWeeksAgoUrgency() throws {
        let task = taskVM.tasks[0]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 9.427, accuracy: 0.001)
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
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), 9.105, accuracy: 0.001)
    }
    
    func testCreatedTwoMonths() throws {
        let task = taskVM.tasks[9]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), -2.789, accuracy: 0.001)
    }
    
    func testCreatedTwoDaysAgoUrgency() throws {
        let task = taskVM.tasks[7]
        
        XCTAssertEqual(spinVM.scoreUrgency(of: task), -8.586, accuracy: 0.001)
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
