import SwiftUI

struct MoreSheetView: View {
    
    let moreOptions: [String] = [
        "Rename list",
        "Delete list",
        "Show/Hide completed tasks",
        "Delete all completed tasks",
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ForEach(moreOptions, id: \.self) { option in
                HStack {
                    Text(option)
                    Spacer()
                }
            }
        }
    }
}
//
//#Preview("main") {
//    MainView()
//        .environmentObject(TaskViewModel(TaskModel.examples))
//        .environmentObject(NavigationCoordinator())
//}

#Preview {
    BottomTabView()
}

#Preview {
    MoreSheetView()
}
