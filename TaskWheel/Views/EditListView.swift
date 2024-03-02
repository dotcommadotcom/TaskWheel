import SwiftUI

struct EditListView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Binding var selected: IconItem?
    @State private var showNewList = false
    @State var newTitleInput: String = ""
    
    private let color = ColorSettings()
    private let newListText = "Create new list"
    private let newTitleDefault = "Enter title of new list"
    
    var body: some View {
        VStack (alignment: .leading, spacing: 13) {
            TextField(newTitleDefault, text: $newTitleInput)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color.accent, lineWidth: 2)
                )
            
            HStack(spacing: 16) {
                Button {
                    showNewList = false
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 14, height: 14)
                }
                
//                Text(newListText)
                
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
            
            
        }
        .padding(27)
    }
}

#Preview {
    EditListView(selected: .constant(.lists))
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
}
