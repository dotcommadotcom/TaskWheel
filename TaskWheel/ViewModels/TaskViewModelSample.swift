import Foundation
import DequeModule

extension TaskViewModel {
    
    static let examples: Deque<TaskListModel> = [
        .init(title: "chores", count: 9),
        .init(title: "notes", count: 2),
        .init(title: "digital cleanse", count: 1),
        .init(title: "to buy", count: 0),
    ]
    
    static let uuids = examples.map { $0.id }
    
    static func tasksExamples() -> Deque<TaskModel> {
        [
            .init(
                  title: "laundry",
                  ofTaskList: uuids[0],
                  isDone: false,
                  date: ago(days: 14)),
            
            .init(title: "research pkms",
                  ofTaskList: uuids[2],
                  isDone: false),
            
            .init(creation: Date(),
                  title: "dishes",
                  ofTaskList: uuids[0],
                  isDone: false,
                  priority: 0),
            
            .init(
                  title: "mop",
                  ofTaskList: uuids[0],
                  isDone: false,
                  details: "where are the clean mop heads?",
                  priority: 1,
                  date: ago(days: 1)),
            
            .init(title: "i hope im not too late to set my demon straight",
                  ofTaskList: uuids[1], isDone: false, priority: 0),
            
            .init(
                  title: "vacuum", ofTaskList: uuids[0], isDone: true,
                  priority: 1),
            
            .init(title: "its all a big circle jerk",
                  ofTaskList: uuids[1],
                  details: "chelsea",
                  priority: 2,
                  date: ago(days: 10)
                 ),
            
            .init(creation: ago(days: 2),
                  title: "water plants",
                  ofTaskList: uuids[0],
                  isDone: false,
                  priority: 2),
            
            .init(
                  title: "throw out trash",
                  ofTaskList: uuids[0],
                  isDone: false,
                  priority: 0,
                  date: Date()),
            
            .init(creation: ago(days: 52),
                  title: "recycle plastic and paper, separate vinyl labels",
                  ofTaskList: uuids[0], isDone: false),
            
            .init(creation: ago(days: 365),
                  title: "wipe countertop", ofTaskList: uuids[0],
                  isDone: false),
            
            .init(
                  title: "fold laundry", ofTaskList: uuids[0], isDone: false,
                  date: fromNow(days: 3)),
            
            .init(title: "change passwords", ofTaskList: uuids[2], isDone: true),
            
            .init(
                  title: "clean bathroom", ofTaskList: uuids[0],
                  isDone: true,
                  priority: 1,
                  date: fromNow(days: 16)),
            
            .init(
                  title: "organize shelf",
                  ofTaskList: uuids[0],
                  isDone: false,
                  priority: 2,
                  date: fromNow(days: 16)),
            
            .init(title: "i want to make [] things, even if nobody cares", ofTaskList: uuids[1], isDone: true),
        ]
    }
}
