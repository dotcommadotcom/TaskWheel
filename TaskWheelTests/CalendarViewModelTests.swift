import XCTest
@testable import TaskWheel

final class CalendarViewModelTests: XCTestCase {
    
    private var vm: CalendarViewModel!
    private var dec1924: Date { date(2024, 12, 19) }
    private var feb2821: Date { date(2021, 2, 28) }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        vm = CalendarViewModel()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        vm = nil
    }
    
    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return vm.calendar.date(from: dateComponents)!
    }
    
    private func string(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    

    // TEST - Adjust month and year
    
    func testAdjustYearBackwards() throws {
        vm.select(this: feb2821)
        
        vm.adjustYear(by: -20)
        
        XCTAssertEqual(vm.yearTitle(), "2001")
    }
    
    func testAdjustYearForward() throws {
        vm.select(this: dec1924)
        
        vm.adjustYear(by: 4)
        
        XCTAssertEqual(vm.yearTitle(), "2028")
    }
    
    func testAdjustMonthBackwards() throws {
        vm.select(this: feb2821)
        
        vm.adjustMonth(by: -2)
        
        XCTAssertEqual(vm.monthTitle(), "December")
        XCTAssertEqual(vm.yearTitle(), "2020")
    }
    
    func testAdjustMonthForward() throws {
        vm.select(this: dec1924)
        
        vm.adjustMonth(by: 1)
        
        XCTAssertEqual(vm.monthTitle(), "January")
        XCTAssertEqual(vm.yearTitle(), "2025")
    }

    // TEST - Selected
    
    func testIsSelectedDateIsFalse() throws {
        vm.select(this: dec1924)
        
        XCTAssertFalse(vm.isSelected(this: feb2821))
    }
    
    func testIsSelectedDateIsTrue() throws {
        vm.select(this: dec1924)
        
        XCTAssertTrue(vm.isSelected(this: dec1924))
    }
    
    func testSelectDate() throws {
        vm.select(this: dec1924)
        
        XCTAssertEqual(string(from: vm.selectedDate), string(from: dec1924))
    }
    
    // TEST - Weeks in month
    
    func testWeeksInMonthFirstWeek() throws {
        let weeks = vm.weeksInMonth(for: dec1924)
        
        let weeksString = weeks.map { week in
            week.map { day in
                string(from: day)
            }
        }
        
        XCTAssertEqual(weeksString, [
            ["2024.11.25", "2024.11.26", "2024.11.27", "2024.11.28", "2024.11.29", "2024.11.30", "2024.12.01"],
            ["2024.12.02", "2024.12.03", "2024.12.04", "2024.12.05", "2024.12.06", "2024.12.07", "2024.12.08"],
            ["2024.12.09", "2024.12.10", "2024.12.11", "2024.12.12", "2024.12.13", "2024.12.14", "2024.12.15"],
            ["2024.12.16", "2024.12.17", "2024.12.18", "2024.12.19", "2024.12.20", "2024.12.21", "2024.12.22"],
            ["2024.12.23", "2024.12.24", "2024.12.25", "2024.12.26", "2024.12.27", "2024.12.28", "2024.12.29"],
            ["2024.12.30", "2024.12.31", "2025.01.01", "2025.01.02", "2025.01.03", "2025.01.04", "2025.01.05"],
        ])
    }
    
    func testWeeksInMonthHasFourWeeks() throws {
        XCTAssertEqual(vm.weeksInMonth(for: feb2821).count, 4)
    }
    
    func testWeeksInMonthHasSixWeeks() throws {
        XCTAssertEqual(vm.weeksInMonth(for: dec1924).count, 6)
    }
    
    func testNextWeek() throws {
        let date = vm.firstOfWeek(for: date(2024, 12, 1))
        
        XCTAssertEqual(string(from: vm.nextWeek(from: date)), "2024.12.02")
    }
    
    func testThisWeek() throws {
        let date = vm.firstOfWeek(for: date(2024, 12, 1))
        
        let thisWeek = vm.thisWeek(startsOn: date)
        let thisWeekString = (0..<7).map { index in
            string(from: thisWeek[index])
        }
        
        XCTAssertEqual(thisWeekString, ["2024.11.25", "2024.11.26", "2024.11.27", "2024.11.28", "2024.11.29", "2024.11.30", "2024.12.01"])
    }
    
    // TEST - Is date in month
    
    func testIsInMonthIsTrueForSelectedDate() throws {
        XCTAssertTrue(vm.isInMonth(this: Date()))
    }
    
    func testIsInMonthIsFalse() throws {
        XCTAssertFalse(vm.isInMonth(this: date(2025, 1, 1), in: dec1924))
    }
    
    func testIsInMonthIsTrue() throws {
        XCTAssertTrue(vm.isInMonth(this: date(2024, 12, 1), in: dec1924))
    }
    
    // TEST - Start date of month
    
    func testStartDateOfMonth() throws {
        XCTAssertEqual(string(from: vm.startDateOfMonth(for: dec1924)), "2024.11.25")
    }
    
    func testFirstOfWeek() throws {
        XCTAssertEqual(string(from: vm.firstOfWeek(for: dec1924)), "2024.12.16")
    }
    
    func testFirstOfMonth() throws {
        XCTAssertEqual(string(from: vm.firstOfMonth(for: dec1924)), "2024.12.01")
    }
    
    // TEST - Constructor
    
    func testXdays() throws {
        XCTAssertEqual(vm.xdays, ["M", "T", "W", "T", "F", "S", "S"])
    }

    func testFirstDayOfTheWeek() throws {
        XCTAssertEqual(vm.calendar.firstWeekday, 2)
    }
    
    func testSelectedDateCustom() throws {
        let custom = CalendarViewModel(selectedDate: dec1924)
        
        XCTAssertEqual(string(from: custom.selectedDate), string(from: dec1924))
    }
    
    func testSelectedDate() throws {
        XCTAssertEqual(string(from: vm.selectedDate), string(from: Date()))
    }
}
