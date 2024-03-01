import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    @State private var topSelection: TopTabItem = .list
    
    private let color = ColorSettings()
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            VStack(spacing: 0) {
                TitleView()
                
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
}

extension MainView {
    private func handleSwipe(translation: CGFloat) {
        if translation < -50 && topSelection == .list {
            topSelection = .wheel
        } else if translation > 50 && topSelection == .wheel {
            topSelection = .list
        }
    }
}


#Preview("main") {
    let taskLists = TaskListModel.examples
    let defaultTaskListID = taskLists[0].id
    
    return MainView()
        .environmentObject(TaskViewModel(TaskModel.examples(ofTaskList: defaultTaskListID), taskLists))
        .environmentObject(NavigationCoordinator())
}

#Preview("dark") {
    let taskLists = TaskListModel.examples
    let defaultTaskListID = taskLists[0].id
    
    return MainView()
        .environmentObject(TaskViewModel(TaskModel.examples(ofTaskList: defaultTaskListID), taskLists))
        .environmentObject(NavigationCoordinator())
        .preferredColorScheme(.dark)
}
