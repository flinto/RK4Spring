//
//  RK4Spring_iOSTests.swift
//  RK4Spring_iOSTests
//
//  Created by Kazuho Okui on 7/18/17.
//  Copyright © 2017 Flinto. All rights reserved.
//

import XCTest
@testable import RK4Spring

class RK4Spring_iOSTests: XCTestCase {

  func testSpring() {

    let tension: Double = 950
    let friction: Double = 60
    let velocity: Double = 0

    let values = RK4SpringAnimation(tension: tension, friction: friction, initialVelocity: velocity)
    XCTAssertEqual(values.count, 22)
    XCTAssertEqual(values.filter({ $0 > 1}).count, 0)

  }


}
