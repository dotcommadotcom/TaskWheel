import SwiftUI

struct ListsSheetView: View {
    
    @State private var selected: String = "Task List 1"
    
    let sampleTaskLists = (1...4).map { "Task List \($0)" }
    private let color = ColorSettings()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 22) {
            ForEach(sampleTaskLists, id: \.self) { taskList in
                view(taskList: taskList)
                    .onTapGesture {
                        click(taskList: taskList)
                    }
            }
            
            Divider()
                .padding(.horizontal, -10)
            
            HStack(spacing: 15) {
                Image(systemName: "plus")
                Text("Create new list")
                Spacer()
            }
        }
    }
    
    private func view(taskList: String) -> some View {
        
        let highlight: Bool = selected == taskList
        
        return HStack(spacing: 15) {
            Image(systemName: highlight ? "record.circle" : "circle")
                .fontWeight(highlight ? .bold : .regular)
                .foregroundStyle(highlight ? color.accent : color.text)
            
            Text(taskList)
            Spacer()
        }
    }
    
    private func click(taskList: String) {
        selected = taskList
    }
}

#Preview("main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
        .environmentObject(NavigationCoordinator())
}

#Preview {
    BottomTabView()
}

#Preview {
    ListsSheetView()
}
