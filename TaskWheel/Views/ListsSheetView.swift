import SwiftUI

struct ListsSheetView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Binding var selected: IconItem?
    @State var newTitleInput: String = ""
    @State private var showNewList = false
    
    private let color = ColorSettings()
    private let newListText = "Create new list"
    private let newTitleDefault = "Enter title of new list"
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 22) {
            ForEach(taskViewModel.taskLists) { taskList in
                taskListRowView(taskList: taskList)
                    .onTapGesture {
                        switchTaskList(taskList)
                    }
            }
            
            Divider()
                .padding(.horizontal, -10)
            
            newListView()
        }
    }
    
}

extension ListsSheetView {
    
    private func taskListRowView(taskList: TaskListModel) -> some View {
        
        let highlight = taskList.id == taskViewModel.currentTaskList.id
        let isDefault = taskList.id == taskViewModel.defaultTaskList.id
        
        return HStack(spacing: 15) {
            Image(systemName: highlight ? "record.circle" : "circle")
                .fontWeight(highlight ? .bold : .regular)
                .foregroundStyle(highlight ? color.accent : color.text)
            
            Text(taskList.title)
                .fontWeight(isDefault ? .bold : .regular)
            
            if isDefault {
                Text("[default]")
                    .padding(.horizontal, -10)
                    .foregroundStyle(.gray.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func newListView() -> some View {
        Button {
            showNewList.toggle()
        } label: {
            HStack(spacing: 15) {
                Image(systemName: "plus")
                Text(newListText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .popover(isPresented: $showNewList) {
            EditListView(selected: $selected)
                .presentationCompactAdaptation(.sheet)
                .presentationDetents([.fraction(0.2)])
                .presentationBackground(color.background)
        }
    }
    
    private func switchTaskList(_ taskList: TaskListModel) {
        taskViewModel.updateCurrentTaskList(taskList)
        selected = nil
    }

}

#Preview("lists sheet") {
    ListsSheetView(selected: .constant(.lists))
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}

//#Preview("bottom tab") {
//    BarView(tabs: [.lists, .order, .more, .add])
//        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
//}
//
