import SwiftUI

struct BottomTabView: View {
    
    @State private var selected: IconItem?
    @State private var sheetHeight: CGFloat = .zero
    
    private let color = ColorSettings()
    private let bottomTabs: [IconItem] = [.lists, .order, .more, .add]
    
    var body: some View {
        HStack(spacing: 30) {
            ForEach(bottomTabs, id: \.self) { tab in
                tabView(tab: tab, isSpace: tab == bottomTabs.last)
            }
        }
        .sheet(item: $selected) { tab in
            sheetView(tab: tab, selected: selected)
        }
        .padding(20)
    }
}

extension BottomTabView {
    
    private func tabView(tab: IconItem, isSpace: Bool) -> some View {
        HStack {
            if isSpace {
                Spacer()
            }
            
            Button {
                selected = tab
            } label: {
                Image(systemName: tab.text)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
            }
        }
    }
    
    private func sheetView(tab: IconItem, selected: IconItem?) -> some View {
        VStack {
            switch tab {
            case .lists: ListsSheetView(selected: $selected)
            case .order: OrderSheetView()
            case .more: MoreSheetView(selected: $selected)
            case .add: AddSheetView()
            default: EmptyView()
            }
        }
        .font(.system(size: 22))
        .padding(30)
        .foregroundStyle(color.text)
        .get(sheetHeight: $sheetHeight)
        .presentationDetents([.height(sheetHeight)])
        .presentationCornerRadius(25)
        .presentationDragIndicator(.hidden)
        .presentationBackground(color.background)
    }
    
//    private func dismissSheet() {
//        selected = nil
//    }
}

struct GetHeightModifier: ViewModifier {
    
    @Binding var sheetHeight: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo -> Color in
                    DispatchQueue.main.async {
                        sheetHeight = max(geo.size.height, 50)
                    }
                    return Color.clear
                }
            )
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

#Preview {
    let taskLists = TaskListModel.examples
    let defaultTaskListID = taskLists[0].id
    
    return BottomTabView()
        .environmentObject(TaskViewModel(TaskModel.examples(ofTaskList: defaultTaskListID), taskLists))
}

//struct OldGetHeightModifier: ViewModifier {
//    @Binding var sheetHeight: CGFloat
//    
//    func body(content: Content) -> some View {
//        content
//            .overlay {
//                GeometryReader { geometry in
//                    Color.clear
//                        .preference(key: SheetHeightPreferenceKey.self, value: geometry.size.height)
//                }
//            }
//            .onPreferenceChange(SheetHeightPreferenceKey.self) { nextHeight in
//                sheetHeight = max(nextHeight, 50)
//            }
//    }
//}
