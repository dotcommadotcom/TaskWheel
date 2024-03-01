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
    TitleView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
