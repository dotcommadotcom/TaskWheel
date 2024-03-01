import SwiftUI

struct TitleView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        HStack {
            Text(taskViewModel.currentTaskList.title)
                .font(.system(size: 25, weight: .bold))
            
            Spacer()
            
            Image(systemName: "gearshape.fill")
                .resizable()
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview {
    let taskLists = TaskListModel.examples
    let defaultTaskListID = taskLists[0].id
    
    return TitleView()
        .environmentObject(TaskViewModel(TaskModel.examples(ofTaskList: defaultTaskListID), taskLists))
}
