import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
//    @State private var path = NavigationPath()
    @State private var isAddShown: Bool = false
    
    private let colorBackground: Color = .seasaltJet
    
    let taskListTitle = "Sample Task List"
    var testText = ""
    
    var body: some View {
        NavigationStack() {
            ZStack(alignment: .bottomTrailing) {
                List {
                    
                    ForEach(taskViewModel.taskList) { task in
                        NavigationLink(value: task) {
                            ListRowView(task: task, action: taskViewModel.toggleComplete)
                            
                        }
                    }
                    .listRowBackground(colorBackground)
                }
                .listStyle(.plain)
                .navigationTitle(taskListTitle)
                .navigationBarTitleDisplayMode(.inline)
                .scrollIndicators(.never)
                .navigationDestination(for: TaskModel.self) { task in
                    UpdateView(task: task)
                }
                
                ButtonImageView(image: "plus", color: Color("crayolaBlue")) {
                    self.isAddShown = true
                }
                .padding(.trailing, 30)
                .sheet(isPresented: $isAddShown, content: {
                    AddView(titleInput: testText, detailsInput: testText)
                })
            }
            .background(colorBackground)
        }
    }
    
}

//#Preview("light") {
//    MainView()
//        .environmentObject(TaskViewModel(TaskModel.examples))
//}
//
//#Preview("dark") {
//    MainView()
//        .preferredColorScheme(.dark)
//        .environmentObject(TaskViewModel(TaskModel.examples))
//}

#Preview("medium text", traits: .sizeThatFitsLayout) {
    @State var mediumText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    return MainView(testText: mediumText)
//        .preferredColorScheme(.dark)
        .environmentObject(TaskViewModel(TaskModel.examples))
}

//#Preview("long text") {
//    @State var longText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//    
//    return MainView(testText: String(repeating: longText, count: 5))
//        .preferredColorScheme(.dark)
//        .environmentObject(TaskViewModel(TaskModel.examples))
//}
