import SwiftUI

@main
struct TaskWheelApp: App {
    
    @StateObject var taskViewModel: TaskViewModel = TaskViewModel(TaskModel.examples)
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(taskViewModel)
        }
    }
}
