import SwiftUI

struct BottomTabType: Identifiable, Hashable {
    var id: String
    var icon: String
}

struct BottomTabView: View {
    @State private var selected: BottomTabType?
    @State private var sheetHeight: CGFloat = .zero
    
    let sampleTaskLists = (1...4).map { "Task List \($0)" }
    let color = ColorSettings()
    
    let bottomTabs: [BottomTabType] = [
        BottomTabType(id: "lists", icon: "list.dash"),
        BottomTabType(id: "reorder", icon: "arrow.up.arrow.down"),
        BottomTabType(id: "more", icon: "ellipsis"),
        BottomTabType(id: "add", icon: "plus.square"),
    ]
    
    var body: some View {
        HStack(spacing: 25) {
            ForEach(bottomTabs, id: \.self) { tab in
                view(tab: tab, isSpace: tab == bottomTabs.last)
            }
        }
        .sheet(item: $selected) { tab in
            viewSheet(tab: tab)
        }
        .padding(20)
    }
    
    private func view(tab: BottomTabType, isSpace: Bool) -> some View {
        HStack {
            if isSpace {
                Spacer()
            }
            
            Button {
                selected = tab
            } label: {
                Image(systemName: tab.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
            }
        }
    }
    
    private func viewSheet(tab: BottomTabType) -> some View {
        
        VStack {
            switch tab.id {
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
                OrderSheetView()
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
        .get(sheetHeight: $sheetHeight)
        .presentationDetents([.height(sheetHeight)])
        .presentationCornerRadius(25)
        .presentationDragIndicator(.hidden)
        .presentationBackground(color.background)
    }
    
    private func dismissSheet() {
        selected = nil
    }
}

struct GetHeightModifier: ViewModifier {
    
    @Binding var sheetHeight: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: SheetHeightPreferenceKey.self, value: geometry.size.height)
                }
            }
            .onPreferenceChange(SheetHeightPreferenceKey.self) { nextHeight in
                sheetHeight = max(nextHeight, 50)
            }
    }
}

extension View {
    func get(sheetHeight: Binding<CGFloat>) -> some View {
        self
            .modifier(GetHeightModifier(sheetHeight: sheetHeight))
    }
}

struct SheetHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


#Preview("main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
        .environmentObject(NavigationCoordinator())
}

#Preview {
    BottomTabView()
}



struct OldGetHeightModifier: ViewModifier {
    @Binding var height: CGFloat
    private let heightMaximum: CGFloat = 500
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo -> Color in
                    DispatchQueue.main.async {
                        height = max(geo.size.height, 50)
                    }
                    return Color.clear
                }
            )
    }
}
