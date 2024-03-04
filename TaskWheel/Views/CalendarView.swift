import SwiftUI

struct CalendarView: View {
    
    @StateObject var calendarVM = CalendarViewModel()
    private let color = ColorSettings()
    
    
    var body: some View {
        ZStack {
            
            Color(color.background)
            
            VStack {
                monthYearView()
                
                daysView()
                
                weeksView()
            }
        }
        .foregroundStyle(color.text)
    }
    
}

extension CalendarView {
    
    private func monthYearView() -> some View {
        HStack {
            HStack {
                Image(systemName: "chevron.left")
                Text("March")
                Image(systemName: "chevron.right")
            }
            
            HStack {
                Image(systemName: "chevron.left")
                Text("2024")
                Image(systemName: "chevron.right")
            }
        }
    }
    
    private func daysView() -> some View {
        HStack {
            ForEach(calendarVM.days, id: \.self) { day in
                Text("\(day)")
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func weeksView() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(calendarVM.weeks, id: \.self) { week in
                ForEach(week, id: \.self) { day in
                    Text("\(calendarVM.calendar.component(.day, from: day))")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .opacity(isDateInCurrentMonth(day) ? 1 : 0.5)
                }
            }
        }
    }
}

extension CalendarView {
    
    private func isDateInCurrentMonth(_ thisDay: Date) -> Bool {
        return calendarVM.calendar.isDate(thisDay, equalTo: calendarVM.date, toGranularity: .month)
    }
    
}

#Preview("calendar") {
    CalendarView()
}
