import SwiftUI

@main
struct TaskWheelApp: App {
    
    @StateObject var taskViewModel: TaskViewModel
    @StateObject var navigation: NavigationCoordinator  = NavigationCoordinator()
    
    init() {
        _taskViewModel = StateObject(wrappedValue: TaskViewModel(
//            TaskViewModel.tasksExamples(),
//            TaskViewModel.examples)
        )
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(taskViewModel)
                .environmentObject(navigation)
        }
    }
}
