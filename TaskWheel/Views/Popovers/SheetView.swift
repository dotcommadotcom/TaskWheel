import SwiftUI

extension View {
    func popSheet(selected: Binding<IconItem?>) -> some View {
        self
            .modifier(SheetViewModifier(selected: selected))
    }
    
    func popPriority(show: Binding<Bool>, input: Binding<PriorityItem>) -> some View {
        self
            .modifier(PriorityViewModifer(show: show, input: input))
    }
    
    func popSchedule(show: Binding<Bool>, input: Binding<Date?>) -> some View {
        self
            .modifier(ScheduleViewModifer(show: show, input: input))
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

struct SheetViewModifier: ViewModifier {
    
    @Binding var selected: IconItem?
    @State private var sheetHeight: CGFloat = .zero
    
    func body(content: Content) -> some View {
        content
            .popover(item: $selected) { _ in
                SheetView(selected: $selected)
                    .presentSheet($sheetHeight)
            }
    }
}

struct SheetView: View {
    
    @Binding var selected: IconItem?
    
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
    }
}

struct PriorityViewModifer: ViewModifier {
    
    @Binding var show: Bool
    @Binding var input: PriorityItem
    @State private var sheetHeight: CGFloat = .zero
    
    func body(content: Content) -> some View {
        content
            .popover(isPresented: $show) {
                VStack(alignment: .leading, spacing: 22) {
                    PrioritySheetView(selected: $input, showPriority: $show)
                }
                .presentSheet($sheetHeight)
            }
    }
}

struct ScheduleViewModifer: ViewModifier {
    
    @Binding var show: Bool
    @Binding var input: Date?
    @State private var sheetHeight: CGFloat = .zero
    
    func body(content: Content) -> some View {
        content
            .popover(isPresented: $show) {
                VStack(alignment: .leading, spacing: 22) {
                    CalendarView(dateInput: $input)
                }
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
            .font(.system(size: 22))
            .padding(30)
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

#Preview() {
    MainView()
        .environmentObject(TaskViewModel(TaskViewModel.tasksExamples(), TaskViewModel.examples))
        .environmentObject(NavigationCoordinator())
}
