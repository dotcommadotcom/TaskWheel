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
        
        return round(urgency)
    }
    
    func weights(of tasks: Deque<TaskModel>) -> [Double] {
        return tasks.map { round(scoreImportance(of: $0) + scoreUrgency(of: $0)) }
    }
//    
//    func selectRandomTaskWithWeights() -> TaskModel? {
//        guard !tasks.isEmpty else {
//            return nil
//        }
//        
//        let weights = weights()
//        
//        let totalWeight = weights.reduce(0, +)
//        let randomValue = Double.random(in: 0.0..<totalWeight)
//        
//        var cumulativeWeight = 0.0
//        for (index, task) in tasks.enumerated() {
//            cumulativeWeight += weights[index]
//            if randomValue < cumulativeWeight {
//                return task
//            }
//        }
//        
//        return nil
//    }

}

