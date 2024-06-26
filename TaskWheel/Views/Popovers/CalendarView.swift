import SwiftUI

struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var calendarVM: CalendarViewModel
    
    @Binding var dateInput: Date?
    
    init(dateInput: Binding<Date?>) {
        self._dateInput = dateInput
        self._calendarVM = StateObject(wrappedValue: CalendarViewModel(selectedDate: dateInput.wrappedValue ?? Date()))
    }
    
    var body: some View {
        VStack(spacing: 25) {
            monthYearView()
            
            daysView()
            
            weeksView()
            
            calendarBarView()
        }
        .smallFont()
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
                Icon(this: .left, size: .xsmall, style: IconOnly())
            }
            
            Text(calendarVM.monthTitle())
                .frame(maxWidth: .infinity)
                .fontWeight(.medium)
            
            Button{
                calendarVM.adjustMonth(by: 1)
            } label: {
                Icon(this: .right, size: .xsmall, style: IconOnly())
            }
        }
        .padding(.horizontal, 10)
    }
    
    private func daysView() -> some View {
        HStack {
            ForEach(calendarVM.xdays, id: \.self) { xday in
                Text("\(xday)")
                    .foregroundStyle(Color.text.opacity(0.75))
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func weeksView() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 20) {
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
                    .fill(isHighlight(day) ? Color.text : .clear)
                
                Text("\(calendarVM.calendar.component(.day, from: day))")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .opacity(calendarVM.isInMonth(this: day) ? 1 : 0.5)
                    .foregroundColor(isHighlight(day) ? Color.background : Color.text)
            }
        }
        .noAnimation()
    }
    
    private func calendarBarView() -> some View {
        
        HStack {
            Button {
                clickCancel()
            } label: {
                Icon(this: .cancel, size: .small, style: IconOnly())
            }
            
            Spacer()
            
            Button {
                clickSave()
            } label: {
                Icon(this: .save, size: .small, style: IconOnly())
            }
        }
        .padding(.horizontal, 10)
    }
}

extension CalendarView {
    
    private func isHighlight(_ day: Date) -> Bool {
        return calendarVM.isSameDay(this: day, as: calendarVM.selectedDate)
    }
    
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
    CalendarView(dateInput: .constant(date(2024, 12, 16)))
}

#Preview("dark calendar") {
    CalendarView(dateInput: .constant(Date()))
        .preferredColorScheme(.dark)
}

