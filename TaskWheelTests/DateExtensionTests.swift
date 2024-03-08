import XCTest
@testable import TaskWheel

final class DateExtensionTests: XCTestCase {
    
    private var calendar: Calendar!
    private var today: Date!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        calendar = Calendar.current
        calendar.firstWeekday = 2
        today = Date()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        calendar = nil
        today = nil
    }
    
    // TEST - Calculate days
    
    func testCalculateDaysFromTomorrow() throws {
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        XCTAssertEqual(tomorrow.calculateDays(), 1)
    }
    
    func testCalculateDaysFromYesterday() throws {
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        XCTAssertEqual(yesterday.calculateDays(), -1)
    }
    
    func testCalculateDaysFromZero() throws {
        XCTAssertEqual(today.calculateDays(), 0)
    }
    
    // TEST - Past
    
    func testIsPastIsFalse() throws {
        XCTAssertFalse(today.isPast())
    }
    
    func testIsPastIsTrue() throws {
        let date = calendar.date(byAdding: .day, value: -1, to: today)!
        
        XCTAssertTrue(date.isPast())
    }
    
    // TEST - Relative date
    
    func testRelativeIsNextYear() throws {
        let firstDate = date(2021, 9, 1)

        let secondDate = date(2022, 9, 21)

        XCTAssertEqual(secondDate.relative(firstDate), "Wed, Sep 21, 2022")
    }
    
    func testRelativeIsMoreThanOneWeekFromNow() throws {
        let firstDate = date(2021, 9, 1)

        let secondDate = date(2021, 9, 21)

        XCTAssertEqual(secondDate.relative(firstDate), "Tue, Sep 21")
    }
    
    func testRelativeIsOneWeekFromNow() throws {
        let days = 7
        
        let date = calendar.date(byAdding: .day, value: days, to: today)!
        
        XCTAssertEqual(date.relative(), "1 week from now")
    }
    
    func testRelativeIsXdaysFromNow() throws {
        let days = 3
        
        let date = calendar.date(byAdding: .day, value: days, to: today)!
        
        XCTAssertEqual(date.relative(), "\(days) days from now")
    }
    
    func testRelativeIsTomorrow() throws {
        let days = 1
        
        let date = calendar.date(byAdding: .day, value: days, to: today)!
        
        XCTAssertEqual(date.calculateDays(), 1)
        XCTAssertEqual(date.relative(), "Tomorrow")
    }
    
    func testRelativeIsMoreThanOneWeekAgo() throws {
        let days = -45
        
        let date = calendar.date(byAdding: .day, value: days, to: today)!
        
        XCTAssertEqual(date.relative(), "7 weeks ago")
    }
    
    func testRelativeIsTenDaysAgo() throws {
        let days = -10
        
        let date = calendar.date(byAdding: .day, value: days, to: today)!
        
        XCTAssertEqual(date.relative(), "2 weeks ago")
    }
    
    func testRelativeIsOneWeekAgo() throws {
        let days = -7
        
        let date = calendar.date(byAdding: .day, value: days, to: today)!
        
        XCTAssertEqual(date.relative(), "1 week ago")
    }

    func testRelativeIsXdate() throws {
        let days = 4
        
        let date = calendar.date(byAdding: .day, value: -days, to: today)!
        
        XCTAssertEqual(date.relative(), "\(days) days ago")
    }
    
    func testRelativeIsYesterday() throws {
        let date = calendar.date(byAdding: .day, value: -1, to: today)!
        
        XCTAssertEqual(date.relative(), "Yesterday")
    }
    
    func testRelativeIsToday() throws {
        XCTAssertEqual(today.relative(), "Today")
    }
}
