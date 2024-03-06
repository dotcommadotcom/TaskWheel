import XCTest
@testable import TaskWheel

final class DateExtensionTests: XCTestCase {
    
    private var calendar: Calendar!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        calendar = Calendar.current
        calendar.firstWeekday = 2
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        calendar = nil
    }
    
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
        let days = 8
        
        let date = calendar.date(byAdding: .day, value: days, to: Date())!
        
        XCTAssertEqual(date.relative(), "1 week from now")
    }
    
    func testRelativeIsXdaysFromNow() throws {
        let days = 3
        
        let date = calendar.date(byAdding: .day, value: days, to: Date())!
        
        XCTAssertEqual(date.relative(), "\(days - 1) days from now")
    }
    
    func testRelativeIsMoreThanOneWeekAgo() throws {
        let days = -45
        
        let date = calendar.date(byAdding: .day, value: days, to: Date())!
        
        XCTAssertEqual(date.relative(), "6 weeks ago")
    }
    
    func testRelativeIsTenDaysAgo() throws {
        let days = -10
        
        let date = calendar.date(byAdding: .day, value: days, to: Date())!
        
        XCTAssertEqual(date.relative(), "2 weeks ago")
    }
    
    func testRelativeIsOneWeekAgo() throws {
        let days = -7
        
        let date = calendar.date(byAdding: .day, value: days, to: Date())!
        
        XCTAssertEqual(date.relative(), "1 week ago")
    }

    func testRelativeIsXdate() throws {
        let days = 4
        
        let date = calendar.date(byAdding: .day, value: -days, to: Date())!
        
        XCTAssertEqual(date.relative(), "\(days) days ago")
    }
    
    func testRelativeIsYesterday() throws {
        let date = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        XCTAssertEqual(date.relative(), "Yesterday")
    }
    
    func testRelativeIsToday() throws {
        XCTAssertEqual(Date().relative(), "Today")
    }
}
