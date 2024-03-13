import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var navigation: NavigationCoordinator
    
    @State private var tabSelected: TabItem = .list
    @State private var barSelected: IconItem? = nil
    
    private let mainIcons: [IconItem] = [.order, .option, .add]
    
    var body: some View {
        NavigationStack(path: $navigation.path) {
            VStack(spacing: 0) {
                
                TitleView(size: .large, fontWeight: .bold, hideIcon: true)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                TabContainerView(tabSelected: $tabSelected) {
                    ListView()
                        .showTab(this: .list, selected: $tabSelected)
                    
                    WheelView(taskViewModel: taskViewModel)
                        .showTab(this: .wheel, selected: $tabSelected)
                }
                .highPriorityGesture(DragGesture().onEnded({
                    handleSwipe(width: $0.translation.width)
                }))
                
                mainBarView()
                    .background(Color.text.opacity(0.05))
            }
            .background(Color.background)
            .foregroundStyle(Color.text)
            .animation(.easeInOut, value: tabSelected)
            .noAnimation()
            .navigationDestination(for: TaskModel.self) { task in
                TaskView(task: task)
            }
        }
    }
}

extension MainView {
    
    private func mainBarView() -> some View {
        HStack(spacing: 30) {
            ForEach(mainIcons, id: \.self) { icon in
                if icon == mainIcons.last {
                    Spacer()
                }
                
                Button {
                    barSelected = icon
                } label: {
                    Icon(this: icon, size: .custom(25), style: IconOnly())
                }
            }
        }
        .padding(20)
        .padding(.horizontal, 5)
        .frame(maxWidth: .infinity)
        .popSheet(selected: $barSelected)
    }
    
    private func handleSwipe(width: CGFloat) {
        if width < -50 && tabSelected == .list {
            tabSelected = .wheel
        } else if width > 50 && tabSelected == .wheel {
            tabSelected = .list
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
