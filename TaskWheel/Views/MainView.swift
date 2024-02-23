import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
//    @State private var path = NavigationPath()
    @State private var isAddShown: Bool = false
    
    let color = ColorSettings()
    let taskListTitle = "Sample Task List"
    var testText = ""
    
    var body: some View {
        NavigationStack() {
            ZStack(alignment: .bottomTrailing) {
                TaskListView(taskListTitle: taskListTitle)
                
                Button {
                    isAddShown = true
                } label: {
                    Image(systemName: "plus")
                        .padding(13)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(.seasalt)
                        .background(.crayolaBlue)
                        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.1), radius: 5, x: 5, y: 5)
                        .clipShape(Circle())
                }
                .padding(.trailing, 30)
                .sheet(isPresented: $isAddShown, content: {
                    AddView(titleInput: testText, detailsInput: testText)
                })
            }
            .background(color.background)
        }
    }
    
}

#Preview("light") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
}

#Preview("dark") {
    MainView()
        .preferredColorScheme(.dark)
        .environmentObject(TaskViewModel(TaskModel.examples))
}

//#Preview("medium text", traits: .sizeThatFitsLayout) {
//    @State var mediumText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//    return MainView(testText: mediumText)
////        .preferredColorScheme(.dark)
//        .environmentObject(TaskViewModel(TaskModel.examples))
//}

//#Preview("long text") {
//    @State var longText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//    
//    return MainView(testText: String(repeating: longText, count: 5))
//        .preferredColorScheme(.dark)
//        .environmentObject(TaskViewModel(TaskModel.examples))
//}
