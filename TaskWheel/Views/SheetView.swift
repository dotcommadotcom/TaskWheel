import SwiftUI

struct SheetView: View {
    let selectedTab: BottomTabType
    let sampleTaskLists = (1...4).map { "Task List \($0)" }
    let color = ColorSettings()
    
    var body: some View {
        VStack {
            switch selectedTab.id {
            case "lists":
                VStack {
                    List {
                        ForEach(sampleTaskLists, id: \.self) { taskList in
                            Text(taskList)
                        }
                    }
                    Divider()
                    Text("Create new list")
                        .font(.title)
                }
            case "reorder":
                VStack(alignment: .leading) {
                    Text("Sort by")
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Creation date")
                    }
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Due date")
                    }
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Priority")
                    }
                }
            case "more":
                VStack(alignment: .leading) {
                    Text("Rename list")
                    Text("Delete list")
                    Text("Show/Hide completed tasks")
                    Text("Delete all completed tasks")
                }
            case "add":
                Text("What to add?")
            default:
                EmptyView()
            }
        }
        .presentationDetents([.fraction(0.3)])
        .presentationCornerRadius(25)
        .presentationDragIndicator(.hidden)
        .presentationBackground(color.background)
    }
}


#Preview("main") {
    MainView()
}

#Preview("bottom tab") {
    BottomTabView()
}

