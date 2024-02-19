import SwiftUI

struct MainView: View {
    let taskListTitle = "Sample Task List"
    
    var body: some View {
        NavigationStack() {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(TaskModel.examples) { task in
                        ListRowView(task: task)
                    }
                }
                .toolbarBackground(Color.white, for: .navigationBar)
                .listStyle(.plain)
                .navigationTitle(taskListTitle)
                .navigationBarTitleDisplayMode(.inline)
                .scrollIndicators(.never)
                
                ButtonImageView(image: "plus", color: Color("crayolaBlue")) {
                    print("clicked")
                }
                .padding(.trailing, 30)
            }
        }
    }
}

#Preview {
    MainView()
}
