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

extension Date {

    func string() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: self)
    }
}
