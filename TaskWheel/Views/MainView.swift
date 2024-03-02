import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    @State private var topSelection: TopTabItem = .list
    @State private var barSelection: IconItem? = nil
    @State private var showCompleted: Bool = true
    
    private let color = ColorSettings()
    private let mainTabs: [IconItem] = [.lists, .order, .more, .add]
    
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
               
                BarView(selected: $barSelection, tabs: mainTabs)
                    .background(color.text.opacity(0.05))
                    .sheetItem(selected: $barSelection)
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
    MainView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
        .environmentObject(NavigationCoordinator())
}

#Preview("dark") {
    MainView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
        .environmentObject(NavigationCoordinator())
        .preferredColorScheme(.dark)
}
