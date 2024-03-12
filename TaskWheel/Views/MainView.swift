import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    
    @State private var topSelected: TopTabItem = .list
    @State private var barSelected: IconItem? = nil
    
    private let mainTabs: [IconItem] = [.order, .more, .add]
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            VStack(spacing: 0) {
                
                TitleView(fontSize: 25, fontWeight: .bold, hideIcon: true)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                TopTabContainerView(selected: $topSelected) {
                    ListView()
                        .topTabItem(tab: .list, selected: $topSelected)
                    
                    WheelView(taskViewModel: taskViewModel)
                        .topTabItem(tab: .wheel, selected: $topSelected)
                }
                .highPriorityGesture(DragGesture().onEnded({
                    handleSwipe(width: $0.translation.width)
                }))
                
                mainBarView()
                    .background(Color.text.opacity(0.05))
            }
            .background(Color.background)
            .foregroundStyle(Color.text)
            .animation(.easeInOut, value: topSelected)
            .navigationDestination(for: TaskModel.self) { task in
                TaskView(task: task)
            }
        }
    }
}

extension MainView {
    
    private func mainBarView() -> some View {
        HStack(spacing: 30) {
            ForEach(mainTabs, id: \.self) { tab in
                Icon(this: tab, isSpace: tab == mainTabs.last)
                    .onTapGesture {
                        barSelected = tab
                    }
            }
        }
        .padding(20)
        .padding(.horizontal, 5)
        .frame(maxWidth: .infinity)
        .popSheet(selected: $barSelected)
    }
    
    private func handleSwipe(width: CGFloat) {
        if width < -50 && topSelected == .list {
            topSelected = .wheel
        } else if width > 50 && topSelected == .wheel {
            topSelected = .list
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
