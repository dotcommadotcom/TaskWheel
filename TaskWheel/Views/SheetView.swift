import SwiftUI

struct SheetViewModifier: ViewModifier {
    
    @Binding var selected: IconItem?
    @Binding var order: OrderItem
    
    func body(content: Content) -> some View {
        content
            .popover(item: $selected) { _ in
                SheetView(selected: $selected, order: $order)
            }
    }
}

struct SheetView: View {
    
    @Binding var selected: IconItem?
    @Binding var order: OrderItem
    @State private var sheetHeight: CGFloat = .zero
    let color = ColorSettings()
    
    var body: some View {
        VStack {
            switch selected {
            case .lists: ListsSheetView()
            case .order: OrderSheetView(selected: $order)
            case .more: MoreSheetView()
            case .add: AddSheetView()
            default: EmptyView()
            }
        }
        .font(.system(size: 22))
        .padding(30)
        .presentSheet($sheetHeight)
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

struct SheetPresentationModifier: ViewModifier {
    
    @Binding var sheetHeight: CGFloat
    private let color = ColorSettings()
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color.text)
            .presentationCompactAdaptation(.sheet)
            .getSheetHeight($sheetHeight)
            .presentationDetents([.height(sheetHeight)])
            .presentationCornerRadius(25)
            .presentationDragIndicator(.hidden)
            .presentationBackground(color.background)
    }
}

extension View {
    func sheetItem(selected: Binding<IconItem?>, order: Binding<OrderItem>) -> some View {
        self
            .modifier(SheetViewModifier(selected: selected, order: order))
    }
    
    func getSheetHeight(_ sheetHeight: Binding<CGFloat>) -> some View {
        self
            .modifier(SheetHeightModifier(sheetHeight: sheetHeight))
    }
    
    func presentSheet(_ sheetHeight: Binding<CGFloat>) -> some View {
        self
            .modifier(SheetPresentationModifier(sheetHeight: sheetHeight))
    }
}


#Preview {
    SheetView(selected: .constant(nil), order: .constant(.manual))
}