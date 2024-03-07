import Foundation
import DequeModule

class SpinViewModel: ObservableObject {
    
    @Published var selectedTask: TaskModel?
    
    let taskVM: TaskViewModel
    let tasks: Deque<TaskModel>
    var weights: [Double]
    
    init(taskVM: TaskViewModel) {
        self.selectedTask = nil
        self.taskVM = taskVM
        self.tasks = taskVM.currentTasks()
        self.weights = initalizeWeights(count: 2)
//        taskVM.currentCount())
    }
    
    func scoreImportance(of task: TaskModel) -> Int {
        return 4 - task.priority
    }
    
    func initalizeWeights(count: Int) -> [Double]{
        let weights = Array(repeating: 0.0, count: count)
        
        return weights
    }
    
    func selectRandomTaskWithWeights() -> TaskModel? {
        guard !tasks.isEmpty, tasks.count == weights.count else {
            return nil
        }
        
        let totalWeight = weights.reduce(0, +)
        let randomValue = Double.random(in: 0.0..<totalWeight)
        
        var cumulativeWeight = 0.0
        for (index, task) in tasks.enumerated() {
            cumulativeWeight += weights[index]
            if randomValue < cumulativeWeight {
                return task
            }
        }
        
        return nil
    }

}

