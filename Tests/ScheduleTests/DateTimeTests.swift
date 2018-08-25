//
//  DateTimeTests.swift
//  Schedule
//
//  Created by Quentin Jin on 2018/7/2.
//

import XCTest
@testable import Schedule

final class DateTimeTests: XCTestCase {

    func testInterval() {

        XCTAssertTrue((-1).second.isNegative)
        XCTAssertEqual(1.1.second.magnitude, 1.1.second.nanoseconds)

        XCTAssertTrue(1.1.second.isLonger(than: 1.0.second))
        XCTAssertTrue(3.days.isShorter(than: 1.week))
        XCTAssertEqual(Interval.longest(1.hour, 1.day, 1.week), 1.week)
        XCTAssertEqual(Interval.shortest(1.hour, 59.minutes, 3000.seconds), 3000.seconds)

        XCTAssertTrue(1.1.second > 1.0.second)
        XCTAssertTrue(3.days < 1.week)
        XCTAssertTrue(4.day >= 4.days)
        XCTAssertTrue(0.seconds <= 0.seconds)

        XCTAssertEqual(1.second * 60, 1.minute)
        XCTAssertEqual(59.minutes + 60.seconds, 1.hour)
        XCTAssertEqual(1.week - 24.hours, 6.days)
        XCTAssertEqual(-(1.second), (-1).second)

        XCTAssertEqual(1.nanoseconds, Interval(nanoseconds: 1))
        XCTAssertEqual(2.microseconds, Interval(nanoseconds: 2.microseconds.nanoseconds))
        XCTAssertEqual(3.milliseconds, Interval(nanoseconds: 3.milliseconds.nanoseconds))
        XCTAssertEqual(4.seconds, Interval(nanoseconds: 4.seconds.nanoseconds))
        XCTAssertEqual(5.1.minutes, Interval(nanoseconds: 5.1.minutes.nanoseconds))
        XCTAssertEqual(6.2.hours, Interval(nanoseconds: 6.2.hours.nanoseconds))
        XCTAssertEqual(7.3.days, Interval(nanoseconds: 7.3.days.nanoseconds))
        XCTAssertEqual(8.4.weeks, Interval(nanoseconds: 8.4.weeks.nanoseconds))
    }

    func testTime() {
        let t0 = Time(hour: -1, minute: -2, second: -3, nanosecond: -4)
        XCTAssertNil(t0)

        let t1 = Time("11:12:13.456")
        XCTAssertNotNil(t1)
        XCTAssertEqual(t1?.hour, 11)
        XCTAssertEqual(t1?.minute, 12)
        XCTAssertEqual(t1?.second, 13)
        if let i = t1?.nanosecond.nanoseconds {
            XCTAssertTrue(i.isAlmostEqual(to: (0.456.second.nanoseconds).nanoseconds, leeway: 0.001.seconds))
        }

        let t2 = Time("11 pm")
        XCTAssertNotNil(t2)
        XCTAssertEqual(t2?.hour, 23)

        let t3 = Time("12 am")
        XCTAssertNotNil(t3)
        XCTAssertEqual(t3?.hour, 0)
    }

    func testPeriod() {
        let p0 = (1.year + 2.months + 3.days).tidied(to: .day)
        XCTAssertEqual(p0.years, 1)
        XCTAssertEqual(p0.months, 2)
        XCTAssertEqual(p0.days, 3)

        let p1 = Period("one second")?.tidied(to: .second)
        XCTAssertNotNil(p1)
        XCTAssertEqual(p1!.seconds, 1)
        let p2 = Period("two hours and ten minutes")?.tidied(to: .day)
        XCTAssertNotNil(p2)
        XCTAssertEqual(p2!.hours, 2)
        XCTAssertEqual(p2!.minutes, 10)
        let p3 = Period("1 year, 2 months and 3 days")?.tidied(to: .day)
        XCTAssertNotNil(p3)
        XCTAssertEqual(p3!.years, 1)
        XCTAssertEqual(p3!.months, 2)
        XCTAssertEqual(p3!.days, 3)

        let date = Date(year: 1989, month: 6, day: 4) + 1.year
        let year = date.dateComponents.year
        XCTAssertEqual(year, 1990)

        let p4 = Period(hours: 25).tidied(to: .day)
        XCTAssertEqual(p4.days, 1)
    }

    static var allTests = [
        ("testInterval", testInterval),
        ("testTime", testTime),
        ("testPeriod", testPeriod)
    ]
}
