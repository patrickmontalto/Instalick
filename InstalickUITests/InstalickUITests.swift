//
//  InstalickUITests.swift
//  InstalickUITests
//
//  Created by Patrick Montalto on 6/29/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import XCTest

class InstalickUITests: XCTestCase {
        
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
}
