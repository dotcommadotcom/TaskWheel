import SwiftUI

struct ListsSheetView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var newTitleInput: String = ""
    @State private var showNewList = false
    
    private let color = ColorSettings()
    private let newListText = "Create new list"
    private let newTitleDefault = "Enter title"
    
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
        
        let highlight = taskList.id == taskViewModel.getCurrentId()
        
        return HStack(spacing: 15) {
            Image(systemName: highlight ? "record.circle" : "circle")
                .fontWeight(highlight ? .bold : .regular)
                .foregroundStyle(highlight ? color.accent : color.text)
            
            Text(taskList.title)
                .fontWeight(highlight ? .bold : .regular)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func newListView() -> some View {
        VStack {
            HStack(spacing: 15) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showNewList.toggle()
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .rotationEffect(Angle(degrees: !showNewList ? 0 : 45))
                
                Text(newListText)
                
                Spacer()
                
                if showNewList {
                    Button {
                        clickSave()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .buttonStyle(NoAnimationStyle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if showNewList {
                TextField(newTitleDefault, text: $newTitleInput)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(color.accent, lineWidth: 2)
                    )
                    .lineLimit(1)
            }
        }
    }
}

extension ListsSheetView {
    
    private func switchTaskList(_ taskList: TaskListModel) {
        taskViewModel.updateCurrentTaskList(taskList)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickSave() {
        taskViewModel.addTaskList(title: newTitleInput)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview("lists sheet") {
    ListsSheetView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
