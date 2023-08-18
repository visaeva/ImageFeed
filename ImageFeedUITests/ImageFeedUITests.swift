//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Victoria Isaeva on 14.08.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let login = "visaeva0302@gmail.com"
    private let password = "fix0m5ur"
    private let fullName = "Victoria Isaeva"
    private let userName = "@visaeva"
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(login)
        webView.swipeUp()
        
        let doneButton = app.buttons["Done"]
        doneButton.tap()
        
        sleep(2)
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        
        webView.swipeUp()
        
        sleep(5)
        doneButton.tap()
        
        webView.buttons["Login"].tap()
        sleep(5)
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        cell.swipeUp()
        
        sleep(2)
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy:1)
        
        cellToLike.buttons["noLike"].tap()
        cellToLike.buttons["noLike"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["singleViewBackButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["\(fullName)"].exists)
        XCTAssertTrue(app.staticTexts["\(userName)"].exists)
        
        app.buttons["exit"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(3)
    }
}
