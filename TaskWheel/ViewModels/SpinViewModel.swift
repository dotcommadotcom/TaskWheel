import Foundation
import DequeModule

class SpinViewModel: ObservableObject {
    
    @Published var selectedTask: TaskModel?
    
    let taskVM: TaskViewModel
    let tasks: Deque<TaskModel>
    
    init(taskVM: TaskViewModel) {
        self.selectedTask = nil
        self.taskVM = taskVM
        self.tasks = taskVM.currentTasks()
    }
    
    
    func scoreImportance(of task: TaskModel) -> Int {
        return 4 - task.priority
    }
    
    func scoreUrgency(of task: TaskModel) -> Int {
        if let date = task.date {
            return date.calculateDays()
        }
        return 0
    }
    
    func getWeights(count: Int) -> [Double]{
        let weights = Array(repeating: 0.0, count: count)
        
        return weights
    }
    
    func selectRandomTaskWithWeights() -> TaskModel? {
        guard !tasks.isEmpty else {
            return nil
        }
        
        let weights = getWeights(count: self.tasks.count)
        
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

