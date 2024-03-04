import Foundation

class CalendarViewModel: ObservableObject {
    
    @Published var date = Date()
    var datePublisher: Published<Date>.Publisher { $date }
    
    let dateFormatter = DateFormatter()
    
    let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        return calendar
    }()
    
    var xdays: [String] {
        ["M", "T", "W", "T", "F", "S", "S"]
    }
    
    var weeks: [[Date]] {
        weeksInMonth(for: date)
    }
}

extension CalendarViewModel {
    
    func select(to day: Date) {
        date = day
    }
    
    func adjustMonth(by value: Int) {
        date = calendar.date(byAdding: .month, value: value, to: date) ?? Date()
    }
    
    func adjustYear(by value: Int) {
        date = calendar.date(byAdding: .year, value: value, to: date) ?? Date()
    }
    
    func isSelected(_ day: Date) -> Bool {
        return calendar.isDate(day, equalTo: date, toGranularity: .day)
    }
    
    func isInCurrentMonth(_ day: Date) -> Bool {
        return calendar.isDate(day, equalTo: date, toGranularity: .month)
    }
    
    func monthTitle() -> String {
        dateFormatter.dateFormat = "MMMM"
        
        return dateFormatter.string(from: date)
    }
    
    func yearTitle() -> String {
        dateFormatter.dateFormat = "yyyy"

        return dateFormatter.string(from: date)
    }
    
    func weeksInMonth(for date: Date) -> [[Date]] {
        var weeks = [[Date]]()
        let month = calendar.component(.month, from: date)
        var start = startDateOfMonth(for: date)
        
        for _ in 0..<6 {
            weeks.append(thisWeek(startsOn: start))
            start = nextWeek(from: start)
            
            if !isInMonth(from: start, this: month) {
                break
            }
        }
        
        return weeks
    }
    
    func isInMonth(from date: Date, this month: Int) -> Bool {
        return calendar.component(.month, from: date) == month
    }
    
    func nextWeek(from date: Date) -> Date {
        return calendar.date(byAdding: .weekOfYear, value: 1, to: date)!
    }
    
    func thisWeek(startsOn start: Date) -> [Date] {
        var datesInWeek = [Date]()
        
        for i in 0..<7 {
            let nextDay = calendar.date(byAdding: .day, value: i, to: start)!
            datesInWeek.append(nextDay)
        }
        
        return datesInWeek
    }
    
    func startDateOfMonth(for date: Date) -> Date {
        return firstOfWeek(for: firstOfMonth(for: date))
    }

    func firstOfMonth(for date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)

        return calendar.date(from: components)!
    }
    
    func firstOfWeek(for date: Date) -> Date {
        let weekday = calendar.component(.weekday, from: date)
        let daysToSubtract = (weekday - calendar.firstWeekday + 7) % 7

        return calendar.date(byAdding: .day, value: -daysToSubtract, to: date)!
    }
}

class CalendarViewModel2: ObservableObject {
    
    var calendar = Calendar.current
    @Published var date = Date()
    
    @Published var firstDate: Date?
    @Published var secondDate: Date?
    
    var weeks: [[Date]] {
        calendar.firstWeekday = 2
        var weeks = [[Date]]()
        let range = calendar.range(of: .weekOfYear, in: .month, for: date)!
        for week in range {
            var weekDays = [Date]()
            for day in 1...7 {
                let date = calendar.date(byAdding: .day, value: day-1, to: date.startOfMonth(calendar).startOfWeek(week, calendar: calendar))!
                weekDays.append(date)
            }
            weeks.append(weekDays)
        }
        
        if weeks.count == 5 {
            let startDate = calendar.date(byAdding: .day, value: 1, to: weeks.last!.last!)!
            var weekDays = [startDate]
            for day in 1...6 {
                let date = calendar.date(byAdding: .day, value: day, to: startDate)!
                weekDays.append(date)
            }
            weeks.append(weekDays)
        }
        
        return weeks
    }
    
    var days: [String] {
        ["MO", "TU", "WE", "TH", "FR", "SA", "SU"]
    }
    
    
    
    var selectedDateRange: ClosedRange<Date>? {
        if let firstDate = firstDate, let secondDate = secondDate {
            return firstDate...secondDate
        }
        return nil
    }
    
    init(_ currentDate: Date = Date()) {
        date = currentDate
    }
    
    func selectDay(_ day: Date) {
        if firstDate == nil {
            firstDate = day
        } else if secondDate == nil {
            if let first = firstDate {
                if first > day {
                    secondDate = first
                    firstDate = day
                } else {
                    secondDate = day
                }
            }
        } else {
            firstDate = day
            secondDate = nil
        }
    }
    
    func isToday(day: Date) -> Bool {
        return calendar.isDateInToday(day)
    }
    
    func isDateInRange(day: Date) -> Bool {
        if secondDate == nil {
            if let firstDate {
                return firstDate == day
            }
        } else {
            if let firstDate = firstDate, let secondDate = secondDate {
                return day >= firstDate && day <= secondDate
            }
        }
        return false
    }
    
    func isDateSelected(day: Date) -> Bool {
        if secondDate == nil {
            if let firstDate {
                return firstDate == day
            }
        } else {
            if let firstDate, let secondDate {
                return ((firstDate == day) || (secondDate == day))
            }
        }
        return false
    }
    
    func isFirstDayOfMonth(date: Date) -> Bool {
        let components = calendar.dateComponents([.day], from: date)
        return components.day == 1
    }
    
    func isLastDayOfMonth(date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        let lastDayOfMonth = calendar.range(of: .day, in: .month, for: date)!.upperBound - 1
        return components.day == lastDayOfMonth
    }
    
    func dateToStr(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    func titleForMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date).uppercased()
    }
    
    func titleForYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    func selectBackMonth() {
        date = calendar.date(byAdding: .month, value: -1, to: date) ?? Date()
    }
    
    func selectForwardMonth() {
        date = calendar.date(byAdding: .month, value: 1, to: date) ?? Date()
    }
    
    func selectBackYear() {
        date = calendar.date(byAdding: .year, value: -1, to: date) ?? Date()
    }
    
    func selectForwardYear() {
        date = calendar.date(byAdding: .year, value: 1, to: date) ?? Date()
    }
}
