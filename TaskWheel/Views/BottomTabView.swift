import SwiftUI

enum BottomTabItem: Identifiable, Hashable {
    case lists, order, more, add
    
    var id: Self {
        self
    }
    
    var icon: String {
        switch self {
        case .lists: return "list.dash"
        case .order: return "arrow.up.arrow.down"
        case .more: return "ellipsis"
        case .add: return "plus.square"
        }
    }
}

struct BottomTabView: View {
    @State private var selected: BottomTabItem?
    @State private var sheetHeight: CGFloat = .zero
    
    let color = ColorSettings()
    
    let bottomTabs: [BottomTabItem] = [.lists, .order, .more, .add]
    
    var body: some View {
        HStack(spacing: 30) {
            ForEach(bottomTabs, id: \.self) { tab in
                view(tab: tab, isSpace: tab == bottomTabs.last)
            }
        }
        .sheet(item: $selected) { tab in
            viewSheet(tab: tab)
        }
        .padding(20)
    }
    
    private func view(tab: BottomTabItem, isSpace: Bool) -> some View {
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
    
    private func viewSheet(tab: BottomTabItem) -> some View {
        VStack {
            switch tab {
            case .lists: ListsSheetView()
            case .order: OrderSheetView()
            case .more: MoreSheetView()
            case .add: AddSheetView()
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
    
    private func dismissSheet() {
        selected = nil
    }
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

#Preview("main") {
    MainView()
        .environmentObject(TaskViewModel(TaskModel.examples))
        .environmentObject(NavigationCoordinator())
}

#Preview {
    BottomTabView()
}


struct OldGetHeightModifier: ViewModifier {
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
