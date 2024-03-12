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
    
    private func switchTaskList(to taskList: TaskListModel) {
        taskViewModel.updateCurrentTo(this: taskList)
    }
}

#Preview {
    TaskListView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
