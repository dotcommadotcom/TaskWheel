import SwiftUI

struct TitleView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        HStack {
            Text(taskViewModel.defaultTaskList.title)
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
//
//#Preview("main") {
//    MainView()
//        .environmentObject(TaskViewModel(TaskModel.examples, TaskListModel.examples))
//        .environmentObject(NavigationCoordinator())
//}
//
//#Preview {
//    TitleView()
//        .environmentObject(TaskViewModel(TaskModel.examples, TaskListModel.examples))
//}
