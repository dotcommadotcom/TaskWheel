import SwiftUI

@main
struct TaskWheelApp: App {
    
    @StateObject var taskViewModel: TaskViewModel
    @StateObject var navigation: NavigationCoordinator  = NavigationCoordinator()
    
    init() {
        let taskLists = TaskListModel.examples
        let defaultTaskListID = taskLists[0].id
        
        _taskViewModel = StateObject(wrappedValue: TaskViewModel(TaskModel.examples(ofTaskList: defaultTaskListID), taskLists))
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(taskViewModel)
                .environmentObject(navigation)
        }
    }
}
