import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    @State private var topSelected: TopTabItem = .list
    @State private var barSelected: IconItem? = nil
    @State private var showCompleted: Bool = true
    
    private let color = ColorSettings()
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
                    .background(color.text.opacity(0.05))
            }
            .background(color.background)
            .foregroundStyle(color.text)
            .animation(.easeInOut, value: topSelected)
            .navigationDestination(for: TaskModel.self) { task in
                UpdateView(task: task)
            }
        }
    }
}

extension MainView {
    
    private func titleView() -> some View {
        HStack {
            Text(taskViewModel.getCurrentTitle())
                .font(.system(size: 25, weight: .bold))
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer()
            
            IconView(icon: .settings, isSpace: true, size: 20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private func mainBarView() -> some View {
        BarContainerView(selected: $barSelected) {
            ForEach(mainTabs, id: \.self) { tab in
                IconView(icon: tab, isSpace: tab == mainTabs.last)
                    .onTapGesture {
                        barSelected = tab
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
