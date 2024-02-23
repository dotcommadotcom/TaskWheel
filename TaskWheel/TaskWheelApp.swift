import SwiftUI

@main
struct TaskWheelApp: App {
    
    @StateObject var taskViewModel: TaskViewModel = TaskViewModel(TaskModel.examples)
    @StateObject var navigation: NavigationCoordinator = NavigationCoordinator()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(taskViewModel)
                .environmentObject(navigation)
        }
    }
}
