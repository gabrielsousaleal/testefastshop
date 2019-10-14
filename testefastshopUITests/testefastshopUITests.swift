//
//  testefastshopUITests.swift
//  testefastshopUITests
//
//  Created by Gabriel Sousa on 09/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import XCTest

class testefastshopUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.terminate()
        continueAfterFailure = false
        app.launch()
    
    }

    override func tearDown() {
        app.terminate()
    }

    func testarPesquisa() {
        
        let app = XCUIApplication()
        
        app.buttons["Filmes"].tap()
        
        app.searchFields["Pesquisar por filmes, séries e mais..."].tap()
        
        let hKey = app/*@START_MENU_TOKEN@*/.keys["H"]/*[[".keyboards.keys[\"H\"]",".keys[\"H\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        hKey.tap()
        
        let oKey = app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        oKey.tap()
        
        let mKey = app/*@START_MENU_TOKEN@*/.keys["m"]/*[[".keyboards.keys[\"m\"]",".keys[\"m\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        mKey.tap()
        
        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        mKey.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"buscar\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let verticalScrollBar5PagesCollectionView = app.collectionViews.containing(.other, identifier:"Vertical scroll bar, 5 pages").element
        verticalScrollBar5PagesCollectionView.swipeUp()
        verticalScrollBar5PagesCollectionView.swipeUp()
        verticalScrollBar5PagesCollectionView.swipeUp()
        verticalScrollBar5PagesCollectionView.swipeUp()
        app.collectionViews.children(matching: .cell).element(boundBy: 3).children(matching: .other).element.children(matching: .other).element.swipeUp()
    
    }
    
    func testarDetalhesFilmeComSite(){
        
        app = XCUIApplication()
        
        app.buttons["Filmes"].tap()
        
        app.searchFields["Pesquisar por filmes, séries e mais..."].tap()
        
        let bKey = app/*@START_MENU_TOKEN@*/.keys["B"]/*[[".keyboards.keys[\"B\"]",".keys[\"B\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        bKey.tap()

        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        
        let cKey = app/*@START_MENU_TOKEN@*/.keys["c"]/*[[".keyboards.keys[\"c\"]",".keys[\"c\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        cKey.tap()
        
        let uKey = app/*@START_MENU_TOKEN@*/.keys["u"]/*[[".keyboards.keys[\"u\"]",".keys[\"u\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        uKey.tap()
        
        let rKey = app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rKey.tap()
        aKey.tap()
        uKey.tap()
        
        app.collectionViews.cells.children(matching: .other).element.children(matching: .other).element.tap()
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Informações"]/*[[".buttons[\"Informações\"].staticTexts[\"Informações\"]",".staticTexts[\"Informações\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.staticTexts["Site do filme"]/*[[".buttons[\"Site do filme\"].staticTexts[\"Site do filme\"]",".staticTexts[\"Site do filme\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
                
    }
    
    func testarDetalhesFilmeSemSite(){
        
        app.buttons["Filmes"].tap()
        
        app.searchFields["Pesquisar por filmes, séries e mais..."].tap()
        
        let hKey = app/*@START_MENU_TOKEN@*/.keys["H"]/*[[".keyboards.keys[\"H\"]",".keys[\"H\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        hKey.tap()
        
        let oKey = app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        oKey.tap()
        
        let mKey = app/*@START_MENU_TOKEN@*/.keys["m"]/*[[".keyboards.keys[\"m\"]",".keys[\"m\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        mKey.tap()
        
        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        mKey.tap()
        
        let espaOKey = app/*@START_MENU_TOKEN@*/.keys["espaço"]/*[[".keyboards.keys[\"espaço\"]",".keys[\"espaço\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        espaOKey.tap()
        
        let dKey = app/*@START_MENU_TOKEN@*/.keys["d"]/*[[".keyboards.keys[\"d\"]",".keys[\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        dKey.tap()
        oKey.tap()
        espaOKey.tap()
        
        let pKey = app/*@START_MENU_TOKEN@*/.keys["p"]/*[[".keyboards.keys[\"p\"]",".keys[\"p\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pKey.tap()
        
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        
        let uKey = app/*@START_MENU_TOKEN@*/.keys["u"]/*[[".keyboards.keys[\"u\"]",".keys[\"u\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        uKey.tap()
        app.collectionViews.cells.children(matching: .other).element.children(matching: .other).element.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Informações"]/*[[".buttons[\"Informações\"].staticTexts[\"Informações\"]",".staticTexts[\"Informações\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.staticTexts["Site do filme"]/*[[".buttons[\"Site do filme\"].staticTexts[\"Site do filme\"]",".staticTexts[\"Site do filme\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
