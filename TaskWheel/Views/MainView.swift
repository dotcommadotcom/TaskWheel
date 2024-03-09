import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    
    @State private var topSelected: TopTabItem = .wheel
    @State private var barSelected: IconItem? = nil
    @State private var showCompleted: Bool = true
    
    private let mainTabs: [IconItem] = [.lists, .order, .more, .add]
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            VStack(spacing: 0) {
                
                titleView()
                
                TopTabContainerView(selected: $topSelected) {
                    ListView()
                        .topTabItem(tab: .list, selected: $topSelected)
                    
                    WheelView()
                        .topTabItem(tab: .wheel, selected: $topSelected)
                }
                .highPriorityGesture(DragGesture().onEnded({
                    handleSwipe(translation: $0.translation.width)
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
    
    private func titleView() -> some View {
        HStack {
            Text(taskViewModel.currentTitle())
                .font(.system(size: 25, weight: .bold))
                .lineLimit(1)
            
            Spacer()
            
            Icon(this: .settings, size: 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private func mainBarView() -> some View {
        BarContainerView(selected: $barSelected) {
            ForEach(mainTabs, id: \.self) { tab in
                Icon(this: tab, isSpace: tab == mainTabs.last)
                    .onTapGesture {
                        if tab != .shuffle {
                            barSelected = tab
                        }
                    }
            }
        }
        .sheetItem(selected: $barSelected)
    }
    
    private func handleSwipe(translation: CGFloat) {
        if translation < -50 && topSelected == .list {
            topSelected = .wheel
        } else if translation > 50 && topSelected == .wheel {
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
