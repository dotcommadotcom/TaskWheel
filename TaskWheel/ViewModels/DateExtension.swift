import Foundation

func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
    var calendar = Calendar.current
    calendar.firstWeekday = 2
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    return calendar.date(from: dateComponents)!
}

func ago(days: Int) -> Date {
    var calendar = Calendar.current
    calendar.firstWeekday = 2
    return calendar.date(byAdding: .day, value: -days, to: Date())!
}

func fromNow(days: Int) -> Date {
    var calendar = Calendar.current
    calendar.firstWeekday = 2
    return calendar.date(byAdding: .day, value: days, to: Date())!
}

extension Date {

    func string() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
    
    func relative(_ input : Date? = nil) -> String {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let now = input ?? Date()
        
        if calendar.isDateInToday(self) {
            return "Today"
        }
        
        if calendar.isDateInYesterday(self) {
            return "Yesterday"
        }

        if let days = calendar.dateComponents(
            [.day], from: calendar.startOfDay(for: Date()),
            to: calendar.startOfDay(for: self)).day {
            switch days {
            case (-364)...(-8): return "\(Int(ceil(Double(-days)/7.0))) weeks ago"
            case -7: return "1 week ago"
            case (-6)...(-2): return "\(-days) days ago"
            case 1: return "Tomorrow"
            case 2...6: return "\(days) days from now"
            case 7: return "1 week from now"
            default:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = Calendar.current.isDate(self, equalTo: now, toGranularity: .year) ? "E, MMM d" : "E, MMM d, yyyy"
                return dateFormatter.string(from: self)
            }
        }
        return ""
    }
    
    func isPast() -> Bool {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let components = calendar.dateComponents([.day], from: Date(), to: self)
        
        if let daysDifference = components.day {
            return daysDifference <= -1
        }
        
        return false
    }

    func calculateDays() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day],
                from: calendar.startOfDay(for: Date()),
                to: calendar.startOfDay(for: self))
        return components.day ?? 0
    }
}
