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

struct PropertyViewModifer: ViewModifier {
    
    @State private var sheetHeight: CGFloat = .zero

    @Binding var show: Bool
    @Binding var dateInput: Date?
    @Binding var priorityInput: PriorityItem
    
    let isDate: Bool
    
    func body(content: Content) -> some View {
        content
            .popover(isPresented: $show) {
                VStack(alignment: .leading, spacing: 22) {
                    if isDate {
                        CalendarView(dateInput: $dateInput, showSchedule: $show)
                    } else {
                        PrioritySheetView(selected: $priorityInput, showPriority: $show)
                    }
                }
                .font(.system(size: 22))
                .padding(30)
                .presentSheet($sheetHeight)
            }
    }
}

struct PriorityViewModifer: ViewModifier {
    
    @State private var sheetHeight: CGFloat = .zero

    @Binding var show: Bool
    @Binding var input: PriorityItem
    
    func body(content: Content) -> some View {
        content
            .popover(isPresented: $show) {
                VStack(alignment: .leading, spacing: 22) {
                    PrioritySheetView(selected: $input, showPriority: $show)
                }
                .font(.system(size: 22))
                .padding(30)
                .presentSheet($sheetHeight)
            }
    }
}

struct ScheduleViewModifer: ViewModifier {
    
    @State private var sheetHeight: CGFloat = .zero

    @Binding var show: Bool
    @Binding var input: Date?
    
    func body(content: Content) -> some View {
        content
            .popover(isPresented: $show) {
                VStack(alignment: .leading, spacing: 22) {
                    CalendarView(dateInput: $input, showSchedule: $show)
                }
                .padding(30)
                .presentSheet($sheetHeight)
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
    
    func popPriority(show: Binding<Bool>, input: Binding<PriorityItem>) -> some View {
        self
            .modifier(PriorityViewModifer(show: show, input: input))
    }
    
    func popSchedule(show: Binding<Bool>, input: Binding<Date?>) -> some View {
        self
            .modifier(ScheduleViewModifer(show: show, input: input))
    }
    
    func popProperty(show: Binding<Bool>, dateInput: Binding<Date?>, priorityInput: Binding<PriorityItem>) -> some View {
        
        let isDate = dateInput.wrappedValue == nil ? false: true
        
        return self
            .modifier(PropertyViewModifer(show: show, dateInput: dateInput, priorityInput: priorityInput, isDate: isDate))
    }
}


#Preview {
    SheetView(selected: .constant(nil))
}
