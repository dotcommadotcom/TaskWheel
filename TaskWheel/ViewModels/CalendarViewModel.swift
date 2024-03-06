import Foundation

class CalendarViewModel: ObservableObject {
    
    @Published var selectedDate: Date
    
    let dateFormatter = DateFormatter()
    
    let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        return calendar
    }()
    
    var xdays: [String] { ["M", "T", "W", "T", "F", "S", "S"] }
    var weeks: [[Date]] { weeksInMonth(for: selectedDate) }
    
    init(selectedDate: Date = Date()) {
        self.selectedDate = selectedDate
    }
}

extension CalendarViewModel {
    
    func isSameDay(this lhs: Date, as rhs: Date) -> Bool {
        return calendar.isDate(lhs, equalTo: rhs, toGranularity: .day)
    }
    
    func firstOfWeek(for date: Date) -> Date {
        let weekday = calendar.component(.weekday, from: date)
        let daysToSubtract = (weekday - calendar.firstWeekday + 7) % 7

        return calendar.date(byAdding: .day, value: -daysToSubtract, to: date)!
    }

    func firstOfMonth(for date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)

        return calendar.date(from: components)!
    }
    
    func startDateOfMonth(for date: Date) -> Date {
        return firstOfWeek(for: firstOfMonth(for: date))
    }
    
    func isInMonth(this date: Date, in month: Date? = nil) -> Bool {
        let monthToCheck = month ?? selectedDate
        
        return calendar.isDate(date, equalTo: monthToCheck, toGranularity: .month)
    }
    
    func thisWeek(startsOn start: Date) -> [Date] {
        var datesInWeek = [Date]()
        
        for i in 0..<7 {
            let nextDay = calendar.date(byAdding: .day, value: i, to: start)!
            datesInWeek.append(nextDay)
        }
        
        return datesInWeek
    }
    
    func nextWeek(from date: Date) -> Date {
        return calendar.date(byAdding: .weekOfYear, value: 1, to: date)!
    }
    
    func weeksInMonth(for date: Date) -> [[Date]] {
        var weeks = [[Date]]()
        var start = startDateOfMonth(for: date)
        
        for _ in 0..<6 {
            weeks.append(thisWeek(startsOn: start))
            start = nextWeek(from: start)
        }
        
        return weeks
    }
    
    func select(this day: Date) {
        selectedDate = day
    }
    
    func isSelected(this day: Date) -> Bool {
        return calendar.isDate(day, equalTo: selectedDate, toGranularity: .day)
    }
    
    func monthTitle() -> String {
        dateFormatter.dateFormat = "MMMM yyyy"
        
        return dateFormatter.string(from: selectedDate)
    }
    
    func adjustMonth(by value: Int) {
        selectedDate = calendar.date(byAdding: .month, value: value, to: selectedDate) ?? Date()
    }
}
