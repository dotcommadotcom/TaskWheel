import SwiftUI

struct CalendarView: View {
    
    @StateObject var calendarVM = CalendarViewModel()
    @Binding var selectedDate: Date
    
    private let color = ColorSettings()
    
    var body: some View {
        ZStack {
            
            Color(color.background)
            
            VStack(spacing: 30) {
                HStack(spacing: 20) {
                    monthYearView(calendarVM.monthTitle(), action: calendarVM.adjustMonth)
                    
                    monthYearView(calendarVM.yearTitle(), action: calendarVM.adjustYear)
                }
                
                daysView()
                
                weeksView()
            }
            .padding()
        }
        .onReceive(calendarVM.datePublisher) { date in
            self.selectedDate = date
        }
        .foregroundStyle(color.text)
        .font(.system(size: 18))
    }
    
}

extension CalendarView {
    
    private func monthYearView(_ title: String, action: @escaping (Int) -> Void) -> some View {
        HStack {
            Button {
                action(-1)
            } label: {
                Image(systemName: "chevron.left")
            }
            
            Text(title)
                .frame(maxWidth: .infinity)
                .fontWeight(.semibold)
            
            Button{
                action(1)
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
    }
    
    private func daysView() -> some View {
        HStack {
            ForEach(calendarVM.xdays, id: \.self) { xday in
                Text("\(xday)")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(color.text.opacity(0.75))
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
            calendarVM.select(to: day)
        } label: {
            ZStack {
                Circle()
                    .fill(calendarVM.isSelected(day) ? color.text : .clear)
                
                Text("\(calendarVM.calendar.component(.day, from: day))")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .opacity(calendarVM.isInCurrentMonth(day) ? 1 : 0.5)
                    .foregroundColor(calendarVM.isSelected(day) ? color.background : color.text)
            }
        }
    }
}

#Preview("calendar") {
    CalendarView(selectedDate: .constant(Date()))
}

#Preview("dark calendar") {
    CalendarView(selectedDate: .constant(Date()))
        .preferredColorScheme(.dark)
}
