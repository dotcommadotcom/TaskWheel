import SwiftUI


struct TitleView: View {
    
    let taskListTitle: String
    
    var body: some View {
        Text(taskListTitle)
    }
}


#Preview {
    TitleView(taskListTitle: "sample task list")
}
