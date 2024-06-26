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

    // TEST - Adjust month
    
    func testAdjustMonthBackwards() throws {
        vm.select(this: feb2821)
        
        vm.adjustMonth(by: -2)
        
        XCTAssertEqual(vm.monthTitle(), "December 2020")
    }
    
    func testAdjustMonthForward() throws {
        vm.select(this: dec1924)
        
        vm.adjustMonth(by: 1)
        
        XCTAssertEqual(vm.monthTitle(), "January 2025")
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
        
        XCTAssertEqual(vm.selectedDate.string(), dec1924.string())
    }
    
    // TEST - Weeks in month
    
    func testWeeksInMonthFirstWeek() throws {
        let weeks = vm.weeksInMonth(for: dec1924)
        
        let weeksString = weeks.map { week in
            week.map { day in
                day.string()
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
    
    func testWeeksInMonthHasSixWeeks() throws {
        XCTAssertEqual(vm.weeksInMonth(for: dec1924).count, 6)
    }
    
    func testNextWeek() throws {
        let date = vm.firstOfWeek(for: date(2024, 12, 1))
        
        XCTAssertEqual(vm.nextWeek(from: date).string(), "2024.12.02")
    }
    
    func testThisWeek() throws {
        let date = vm.firstOfWeek(for: date(2024, 12, 1))
        
        let thisWeek = vm.thisWeek(startsOn: date)
        let thisWeekString = (0..<7).map { index in
            thisWeek[index].string()
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
        XCTAssertEqual(vm.startDateOfMonth(for: dec1924).string(), "2024.11.25")
    }
    
    func testFirstOfWeek() throws {
        XCTAssertEqual(vm.firstOfWeek(for: dec1924).string(), "2024.12.16")
    }
    
    func testFirstOfMonth() throws {
        XCTAssertEqual(vm.firstOfMonth(for: dec1924).string(), "2024.12.01")
    }
    
    // TEST - Is same day?
    
    func testSelectedDateIsNotPastDate() throws {
        let pastDate = vm.calendar.date(byAdding: .day, value: -1, to: Date())!
        
        XCTAssertFalse(vm.isSameDay(this: vm.selectedDate, as: pastDate))
    }
    
    func testSelectedDateIsToday() throws {
        XCTAssertTrue(vm.isSameDay(this: vm.selectedDate, as: Date()))
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
        
        XCTAssertEqual(custom.selectedDate.string(), dec1924.string())
    }
    
    func testSelectedDate() throws {
        XCTAssertEqual(vm.selectedDate.string(), Date().string())
    }
}
