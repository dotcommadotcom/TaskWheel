import Foundation
import DequeModule

class SpinViewModel: ObservableObject {
    
    @Published var selectedIndex: Int?
    
    init() {
        self.selectedIndex = nil
    }
    
    private func round(_ output: Double) -> Double {
        return (output * 1000).rounded() / 1000
    }
    
    func scoreImportance(of task: TaskModel) -> Double {
        return 3.0 * (3.0 - Double(task.priority))
    }
    
    func scoreUrgency(of task: TaskModel) -> Double {
        var urgency: Double
        
        if let date = task.date {
            urgency = 10.0 - (10.0 / (1.0 + exp(0.2 * (-Double(date.calculateDays())))))
        } else {
            urgency = sqrt(-Double(task.creation.calculateDays())) - 10
        }
        
        return urgency
    }
    
    func score(of task: TaskModel) -> Double {
        return round(scoreImportance(of: task) + scoreUrgency(of: task))
    }
    
    func weights(from tasks: Deque<TaskModel>) -> [Double] {
        let weights = tasks.map { score(of: $0) }
        let minWeight = weights.min() ?? 0
        return weights.map { round($0 + 0.001 + (minWeight < 0 ? -minWeight : 0)) }
    }
    
    func selectRandomIndex(from tasks: Deque<TaskModel>) -> Int {
        guard !tasks.isEmpty else {
            return -1
        }
        
        let weights = weights(from: tasks)
        let randomTarget = Double.random(in: 0.0..<weights.reduce(0, +))
        
        var cumulativeWeight = 0.0
        for (index, weights) in weights.enumerated() {
            cumulativeWeight += weights
            if cumulativeWeight > randomTarget {
                return index
            }
        }
        return -1
    }
}

