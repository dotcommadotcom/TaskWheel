import SwiftUI

struct MainView: View {
    
    let sampleTasks = (1...25).map { "Task \($0)" }
    @State private var topSelection: TopTabItem = .list
    
    let color = ColorSettings()
    
    var body: some View {
        
        VStack {
            TitleView(taskListTitle: "Sample Task List")
//                .background(.indigo)
            
            TopTabContainerView(selected: $topSelection) {
                ListView(taskList: sampleTasks)
                    .topTabItem(tab: .list, selected: $topSelection)
                
                WheelView(taskList: sampleTasks)
                    .topTabItem(tab: .wheel, selected: $topSelection)
            }
            
            Spacer()
            
            BottomTabView()
//                .background(.red)
        }
        .background(color.background)
        .foregroundStyle(color.text)
    }
}

extension View {
   
}

#Preview("main") {
    MainView()
}

#Preview("dark") {
    MainView()
        .preferredColorScheme(.dark)
}

//struct MainView3: View {
//    
//    @EnvironmentObject var taskViewModel: TaskViewModel
//    @EnvironmentObject var navigation: NavigationCoordinator
//    @State private var isAddShown: Bool = false
//    
//    let color = ColorSettings()
//    let taskListTitle = "Sample Task List"
//    var testText = ""
//    
//    var body: some View {
//        NavigationStack(path: $navigation.path) {
//            ZStack(alignment: .bottomTrailing) {
//                TaskListView2(taskListTitle: taskListTitle)
//                
//                Button {
//                    isAddShown = true
//                } label: {
//                    Image(systemName: "plus")
//                        .padding(13)
//                        .font(.system(size: 30, weight: .semibold))
//                        .foregroundStyle(.seasalt)
//                        .background(.crayolaBlue)
//                        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.1), radius: 5, x: 5, y: 5)
//                        .clipShape(Circle())
//                }
//                .padding(.trailing, 30)
//                .sheet(isPresented: $isAddShown, content: {
//                    AddView(titleInput: testText, detailsInput: testText)
//                })
//            }
//            .background(color.background)
//        }
//    }
//    
//}
//#Preview("light") {
//    MainView3()
//        .environmentObject(TaskViewModel(TaskModel.examples))
//        .environmentObject(NavigationCoordinator())
//}
//
//#Preview("dark") {
//    MainView3()
//        .preferredColorScheme(.dark)
//        .environmentObject(TaskViewModel(TaskModel.examples))
//        .environmentObject(NavigationCoordinator())
//}

//#Preview("medium text", traits: .sizeThatFitsLayout) {
//    @State var mediumText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//    return MainView(testText: mediumText)
////        .preferredColorScheme(.dark)
//        .environmentObject(TaskViewModel(TaskModel.examples))
//.environmentObject(NavigationCoordinator())
//}

//#Preview("long text") {
//    @State var longText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//    
//    return MainView(testText: String(repeating: longText, count: 5))
//        .preferredColorScheme(.dark)
//        .environmentObject(TaskViewModel(TaskModel.examples))
//.environmentObject(NavigationCoordinator())
//}
