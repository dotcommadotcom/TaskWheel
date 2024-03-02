import SwiftUI

struct SheetView: View {
    
    @Binding var selected: IconItem?
    @State private var sheetHeight: CGFloat = .zero
    
    private let color = ColorSettings()
    
    var body: some View {
        VStack {
            switch selected {
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
        .getSheetHeight($sheetHeight)
        .presentationDetents([.height(sheetHeight)])
        .presentationCornerRadius(25)
        .presentationDragIndicator(.hidden)
        .presentationBackground(color.background)
    }
}

struct SheetViewModifier: ViewModifier {
    
    @Binding var selected: IconItem?

    func body(content: Content) -> some View {
        content
            .sheet(item: $selected) { _ in
                SheetView(selected: $selected)
            }
    }
}

struct SheetHeightModifier: ViewModifier {
    
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
    func sheetItem(selected: Binding<IconItem?>) -> some View {
        self
            .modifier(SheetViewModifier(selected: selected))
    }
    
    func getSheetHeight(_ sheetHeight: Binding<CGFloat>) -> some View {
        self
            .modifier(SheetHeightModifier(sheetHeight: sheetHeight))
    }
}

#Preview {
    SheetView(selected: .constant(nil))
}
