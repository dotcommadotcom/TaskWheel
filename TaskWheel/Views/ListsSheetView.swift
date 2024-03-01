import SwiftUI

struct ListsSheetView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Binding var selected: IconItem?
    @State var newTitleInput: String = ""
    @State private var showNewList = false
    
    private let color = ColorSettings()
    private let newListText = "Create new list"
    private let newTitleDefault = "Enter list title"
    
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
                createNewListView()
                    .presentationCompactAdaptation(.sheet)
                    .presentationDetents([.fraction(0.2)])
                    .presentationBackground(color.background)
            }
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
            
            if isDefault {
                Text("(default)")
                    .padding(.vertical, -5)
                    .foregroundStyle(.gray.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func createNewListView() -> some View {
        VStack (alignment: .leading, spacing: 13) {
            HStack(spacing: 16) {
                Button {
                    showNewList = false
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 14, height: 14)
                }
                
                Text(newListText)
                
                Spacer()
                
                Button {
                    taskViewModel.addTaskList(title: newTitleInput)
                    selected = nil
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 14, height: 17)
                }
            }
            
            TextField(newTitleDefault, text: $newTitleInput)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color.accent, lineWidth: 2)
                )
        }
        .padding(27)
    }
    
    private func switchTaskList(_ taskList: TaskListModel) {
        taskViewModel.updateCurrentTaskList(taskList: taskList)
        selected = nil
    }
    
    //    private func (_ taskList: TaskListModel) {
    //        taskViewModel.updateCurrentTaskList(taskList: taskList)
    //        selected = nil
    //    }
}

#Preview("lists sheet") {
    let taskLists = TaskListModel.examples
    let defaultTaskListID = taskLists[0].id
    
    return ListsSheetView(selected: .constant(.lists))
        .environmentObject(TaskViewModel(TaskModel.examples(ofTaskList: defaultTaskListID), taskLists))
}

#Preview("bottom tab") {
    let taskLists = TaskListModel.examples
    let defaultTaskListID = taskLists[0].id
    
    return BottomTabView()
        .environmentObject(TaskViewModel(TaskModel.examples(ofTaskList: defaultTaskListID), taskLists))
}

