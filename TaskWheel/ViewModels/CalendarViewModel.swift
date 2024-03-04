import Foundation

class CalendarViewModel: ObservableObject {
    
    @Published var date = Date()
    let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        return calendar
    }()
    
    var days: [String] {
        ["M", "T", "W", "T", "F", "S", "S"]
    }
    
    var weeks: [[Date]] {
        weeksInMonth(for: date)
    }
}

extension CalendarViewModel {
    
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

