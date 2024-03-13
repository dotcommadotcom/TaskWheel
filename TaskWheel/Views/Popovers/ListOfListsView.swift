import SwiftUI

struct ListOfListsView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var titleInput: String = ""
    @State private var showNewList = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            taskListsView()
            
            Divider()
                .padding(.horizontal, -10)
            
            newListView()
        }
    }
    
}

extension ListOfListsView {
    
    private func taskListsView() -> some View {
        LazyVStack(spacing: 22) {
            ForEach(taskViewModel.taskLists) { taskList in
                let highlight = taskList.id == taskViewModel.currentId()
                
                Button {
                    switchTaskList(to: taskList)
                } label: {
                    Icon(
                        this: .select,
                        style: Default(spacing: 15),
                        color: highlight ? Color.accent : Color.text, isAlt: highlight
                    ) {
                        Text(taskList.title)
                            .fontWeight(highlight ? .bold : .regular)
                        
                        Spacer()
                        
                        Text(String(taskList.count)).greyed()
                            .xsmallFont()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(highlight ? .bold : .regular)
                }
            }
        }
    }
    
    private func newListView() -> some View {
        VStack {
            HStack(spacing: 15) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        toggleNewList()
                    }
                } label: {
                    Icon(this: .plus,
                         style: Default(spacing: 15)
                    ) {
                        Text("Create new list")
                    }
                }
                
                if showNewList {
                    Spacer()
                    
                    Button {
                        clickSave()
                    } label: {
                        Icon(this: .save, style: IconOnly())
                    }
                    .disableClick(if: titleInput.isEmpty)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if showNewList {
                TextField("Enter title", text: $titleInput)
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

extension ListOfListsView {
    
    private func switchTaskList(to taskList: TaskListModel) {
        taskViewModel.updateCurrentTo(this: taskList)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func toggleNewList() {
        titleInput = ""
        showNewList.toggle()
    }
    
    private func clickSave() {
        if !titleInput.isEmpty {
            taskViewModel.addTaskList(title: titleInput)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview("lists sheet") {
    ListOfListsView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
