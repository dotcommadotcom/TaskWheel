import SwiftUI

struct SheetViewModifier: ViewModifier {
    
    @Binding var selected: IconItem?
    
    func body(content: Content) -> some View {
        content
            .popover(item: $selected) { _ in
                SheetView(selected: $selected)
            }
    }
}

struct SheetView: View {
    
    @Binding var selected: IconItem?
    @State private var sheetHeight: CGFloat = .zero
<<<<<<< HEAD:TaskWheel/Views/SheetView.swift
    @State var task: TaskModel?
    let color = ColorSettings()
=======
>>>>>>> 0306:TaskWheel/Views/Popovers/SheetView.swift
    
    var body: some View {
        VStack {
            switch selected {
            case .lists: ListsSheetView()
            case .order: OrderSheetView()
            case .more: MoreSheetView()
            case .add: TaskView()
            default: EmptyView()
            }
        }
        .font(.system(size: 22))
        .padding(30)
        .presentSheet($sheetHeight)
    }
}

struct SheetOnTaskViewModifier: ViewModifier {
    
    @Binding var selected: IconItem?
    
    func body(content: Content) -> some View {
        content
            .popover(item: $selected) { _ in
                SheetOnTaskView(selected: $selected)
            }
    }
}

struct SheetOnTaskView: View {
    
    @Binding var selected: IconItem?
    @State private var sheetHeight: CGFloat = .zero
    @State var task: TaskModel?
    let color = ColorSettings()
    
    var body: some View {
        VStack {
            switch selected {
            case .priority: Prior()
            case .schedule: OrderSheetView()
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
    
    func body(content: Content) -> some View {
        content
            .fixedSize(horizontal: false, vertical: true)
            .foregroundStyle(Color.text)
            .presentationCompactAdaptation(.sheet)
            .getSheetHeight($sheetHeight)
            .presentationDetents([.height(sheetHeight)])
            .presentationCornerRadius(25)
            .presentationDragIndicator(.hidden)
            .presentationBackground(Color.background)
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
    
    func presentSheet(_ sheetHeight: Binding<CGFloat>) -> some View {
        self
            .modifier(SheetPresentationModifier(sheetHeight: sheetHeight))
    }
}


#Preview {
    SheetView(selected: .constant(nil))
}
