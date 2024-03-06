import SwiftUI

struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var calendarVM: CalendarViewModel
    @State var optionSelected: IconItem? = nil
    
    @Binding var dateInput: Date?
    @Binding var showSchedule: Bool
    
    private let optionTabs: [IconItem] = [.cancel, .save]
    
    init(dateInput: Binding<Date?>, showSchedule: Binding<Bool>) {
        self._dateInput = dateInput
        self._calendarVM = StateObject(wrappedValue: CalendarViewModel(selectedDate: dateInput.wrappedValue ?? Date()))
        self._showSchedule = showSchedule
    }
    
    var body: some View {
        VStack(spacing: 20) {
            monthYearView()
            
            daysView()
            
            weeksView()
            
            calendarBarView()
        }
        .font(.system(size: 18))
        .background(Color.background)
        .foregroundStyle(Color.text)
        .highPriorityGesture(DragGesture().onEnded({
            handleSwipe(translation: $0.translation.width)
        }))
    }
    
}

extension CalendarView {
    
    private func monthYearView() -> some View {
        HStack {
            Button {
                calendarVM.adjustMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
            }
            
            Text(calendarVM.monthTitle())
                .frame(maxWidth: .infinity)
                .fontWeight(.semibold)
            
            Button{
                calendarVM.adjustMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .buttonStyle(NoAnimationStyle())
    }
    
    private func daysView() -> some View {
        HStack {
            ForEach(calendarVM.xdays, id: \.self) { xday in
                Text("\(xday)")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.text.opacity(0.75))
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func weeksView() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 22) {
            ForEach(calendarVM.weeks, id: \.self) { week in
                ForEach(week, id: \.self) { day in
                    dayButton(day)
                }
            }
        }
    }
    
    private func dayButton(_ day: Date) -> some View {
        Button {
            calendarVM.select(this: day)
        } label: {
            ZStack {
                Circle()
                    .fill(calendarVM.selectedDate == day ? Color.text : .clear)
                
                Text("\(calendarVM.calendar.component(.day, from: day))")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .opacity(calendarVM.isInMonth(this: day) ? 1 : 0.5)
                    .foregroundColor(calendarVM.selectedDate == day ? Color.background : Color.text)
            }
        }
    }
    
    private func calendarBarView() -> some View {
        
        HStack {
            IconView(icon: .cancel, size: 20)
                .onTapGesture {
                    clickCancel()
                }
            
            IconView(icon: .save, isSpace: true, size: 20)
                .onTapGesture {
                    clickSave()
                }
        }
        .padding(.horizontal, 10)
    }
}

extension CalendarView {
    
    private func clickCancel() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func clickSave() {
        dateInput = calendarVM.selectedDate
        presentationMode.wrappedValue.dismiss()
    }
    
    private func handleSwipe(translation: CGFloat) {
        if translation < -50 {
            calendarVM.adjustMonth(by: 1)
        } else if translation > 50 {
            calendarVM.adjustMonth(by: -1)
        }
    }
}

#Preview("calendar") {
    CalendarView(dateInput: .constant(date(2024, 12, 16)), showSchedule: .constant(true))
}

#Preview("dark calendar") {
    CalendarView(dateInput: .constant(Date()), showSchedule: .constant(true))
        .preferredColorScheme(.dark)
}

