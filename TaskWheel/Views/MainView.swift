import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    @State private var topSelection: TopTabItem = .list
    
    let taskListTitle = "Sample Task List"
    let color = ColorSettings()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            VStack(spacing: 0) {
                TitleView(title: taskListTitle)
                
                TopTabContainerView(selected: $topSelection) {
                    ListView()
                        .topTabItem(tab: .list, selected: $topSelection)
                    
                    WheelView()
                        .topTabItem(tab: .wheel, selected: $topSelection)
                }
                .highPriorityGesture(DragGesture().onEnded({
                    handleSwipe(translation: $0.translation.width)
                }))
                
                BottomTabView()
                    .background(color.text.opacity(0.05))
            }
            .background(color.background)
            .foregroundStyle(color.text)
            .animation(.easeInOut, value: topSelection)
            .navigationDestination(for: TaskModel.self) { task in
                UpdateView(task: task)
            }
        }
    }
    
    private func handleSwipe(translation: CGFloat) {
        if translation < -50 && topSelection == .list {
            topSelection = .wheel
        } else if translation > 50 && topSelection == .wheel {
            topSelection = .list
        }
    }
}


#Preview("main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
        .environmentObject(NavigationCoordinator())
}

#Preview("dark") {
    MainView()
        .preferredColorScheme(.dark)
        .environmentObject(TaskViewModel(TaskModel.examples))
        .environmentObject(NavigationCoordinator())
}

//#Preview("medium text", traits: .sizeThatFitsLayout) {
//    @State var mediumText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//    return MainView(testText: mediumText)
////        .preferredColorScheme(.dark)
//        .environmentObject(TaskViewModel(TaskModel.examples))
//.environmentObject(NavigationCoordinator())
//}

//#Preview("long text") {
//    @State var longText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//
//    return MainView(testText: String(repeating: longText, count: 5))
//        .preferredColorScheme(.dark)
//        .environmentObject(TaskViewModel(TaskModel.examples))
//.environmentObject(NavigationCoordinator())
//}
