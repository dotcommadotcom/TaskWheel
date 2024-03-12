import SwiftUI

struct ListsSheetView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var newTitleInput: String = ""
    @State private var showNewList = false
    
    private let newListText = "Create new list"
    private let newTitleDefault = "Enter title"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            taskListsView()
            
            Divider()
                .padding(.horizontal, -10)
            
            newListView()
        }
    }
    
}

extension ListsSheetView {
    
    private func taskListsView() -> some View {
        LazyVStack(spacing: 22) {
            ForEach(taskViewModel.taskLists) { taskList in
                taskListRowView(taskList: taskList)
                    .onTapGesture {
                        switchTaskList(to: taskList)
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
    
    private func taskListRowView(taskList: TaskListModel) -> some View {
        
        let highlight = taskList.id == taskViewModel.currentId()
        
        return HStack(spacing: 15) {
            Image(systemName: highlight ? "record.circle" : "circle")
                .fontWeight(highlight ? .bold : .regular)
                .foregroundStyle(highlight ? Color.accent : Color.text)
            
            Text(taskList.title)
                .fontWeight(highlight ? .bold : .regular)
            
            Spacer()
            
            Text(String(taskList.count))
                .greyed()
                .font(.system(size: 15))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func newListView() -> some View {
        VStack {
            HStack(spacing: 15) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        clickCreateOrCancel()
                    }
                } label: {
                    Image(systemName: "plus")
                        .rotationEffect(Angle(degrees: !showNewList ? 0 : 45))
                    Text(newListText)
                }
                
                
                Spacer()
                
                if showNewList {
                    Button {
                        clickSave()
                    } label: {
                        Icon(this: .save)
                    }
                    .noAnimation()
                    .disableClick(if: newTitleInput.isEmpty)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if showNewList {
                TextField(newTitleDefault, text: $newTitleInput)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accent, lineWidth: 2)
                    )
                    .lineLimit(1)
                    .onSubmit {
                        clickSave()
                    }
            }
        }
    }
}

extension ListsSheetView {
    
    private func switchTaskList(to taskList: TaskListModel) {
        taskViewModel.updateCurrentTo(this: taskList)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickCreateOrCancel() {
        showNewList.toggle()
        if !showNewList {
            newTitleInput = ""
        }
    }
    
    private func clickSave() {
        if !newTitleInput.isEmpty {
            taskViewModel.addTaskList(title: newTitleInput)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview("lists sheet") {
    ListsSheetView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
