import SwiftUI

struct TaskListView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var titleInput: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            ZStack(alignment: .leading) {
                if titleInput.isEmpty {
                    Text("Enter title").greyed()
                }
                
                TextField(titleInput, text: $titleInput, axis: .vertical)
                    .lineLimit(1)
                
            }
            .font(.system(size: 25))
            .frame(maxWidth: .infinity)
//            .onSubmit {
//                saveGoBack()
//            }
//            
//            HStack {
//                detailsButton()
//                
//                //maybe default?
//                
//                Spacer()
//                
//                saveButton()
//            }
//            .buttonStyle(NoAnimationStyle())
        }
        .font(.system(size: 20))
//        .onSubmit { clickSave() }
//
//        LazyVStack(spacing: 22) {
//            ForEach(taskViewModel.taskLists) { taskList in
//                taskListRowView(taskList: taskList)
//                    .onTapGesture {
//                        switchTaskList(to: taskList)
//                        presentationMode.wrappedValue.dismiss()
//                    }
//            }
//        }
    }
}

extension TaskListView {
    
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
}

extension TaskListView {
    
    private func switchTaskList(to taskList: TaskListModel) {
        taskViewModel.updateCurrentTo(this: taskList)
    }
}

#Preview {
    TaskListView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
