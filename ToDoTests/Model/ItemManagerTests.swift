//
//  ItemManagerTests.swift
//  ToDo
//
//  Created by Yemi Ajibola on 8/3/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemManagerTests: XCTestCase {

    var sut: ItemManager!
    
    override func setUp() {
        super.setUp()
        
        sut = ItemManager()
    }
    
    override func tearDown() {
        sut.removeAllItems()
        sut = nil
        
        super.tearDown()
    }
    
    func testToDoCount_Initially_ShouldBeZero() {
        
        XCTAssertEqual(sut.toDoCount, 0, "Initially toDo count should be zero")
    }
    
    func testDoneCount_Intitally_ShouldBeZero() {
        let sut = ItemManager()
        
        XCTAssertEqual(sut.doneCount, 0, "Initially toDo count should be zero")
    }
    
    func testToDoCount_AfterAddingOneItem_IsOne() {
        sut.addItem(ToDoItem(title: "Test title"))
        
        XCTAssertEqual(sut.toDoCount, 1, "toDo count should be 1")
    }
    
    func testItemAtIndex_ShouldReturnPreviouslyAddedItem() {
        let item = ToDoItem(title: "Item")
        sut.addItem(item)
        
        let returnedItem = sut.itemAtIndex(0)
        
        XCTAssertEqual(item.title, returnedItem.title, "Should be the same item")
    }
    
    func testCheckingItem_ChangesCountOfToDoAndOfDoneItems() {
        sut.addItem(ToDoItem(title: "First Item"))
        sut.checkItemAtIndex(0)
        
        XCTAssertEqual(sut.toDoCount, 0, "toDoCount should be zero")
        XCTAssertEqual(sut.doneCount, 1, "doneCount should be one")
    }
    
    func testCheckingItem_RemovesItFromToDoItemList() {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "Second")
        
        sut.addItem(firstItem)
        sut.addItem(secondItem)
        
        sut.checkItemAtIndex(0)
        
        XCTAssertEqual(sut.itemAtIndex(0).title, secondItem.title)
    }
    
    func testDoneItemAtIndex_ShouldReturnPreviouslyCheckedItem() {
        
        let item = ToDoItem(title: "Item")
        sut.addItem(item)
        
        sut.checkItemAtIndex(0)
        
        let returnedItem = sut.doneItemAtIndex(0)
        
         XCTAssertEqual(item.title, returnedItem.title, "Should be the same item")
    
    }
    
    func testEqualItems_ShouldBeEqual() {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "First")
        
        XCTAssertEqual(firstItem, secondItem)
    }
    
    func testWhenLocationDiffers_ShouldNotBeEqual() {
        let firstItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 0.0, location: Location(name: "Home"))
        
        
        let secondItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 0.0, location: Location(name: "Office"))
        
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func testRemoveAllitems_ShouldResultInCountsBeZero() {
        sut.addItem(ToDoItem(title: "First"))
        sut.addItem(ToDoItem(title: "Second"))
        sut.checkItemAtIndex(0)
        
        XCTAssertEqual(sut.toDoCount, 1, "toDoCount should be 1")
        XCTAssertEqual(sut.doneCount, 1, "doneCount should be 1")
        
        sut.removeAllItems()
        
        XCTAssertEqual(sut.toDoCount, 0, "toDoCount should be 0")
        XCTAssertEqual(sut.doneCount, 0, "toDoCount should be 0")
    }
    
    func testAddingTheSameItem_DoesNotIncreaseCount() {
        sut.addItem(ToDoItem(title: "First"))
        sut.addItem(ToDoItem(title: "First"))
        
        XCTAssertEqual(sut.toDoCount, 1)
    }
    
    func test_ToDoItemsGetSerialized() {
        var itemManager: ItemManager? = ItemManager()
        
        let firstItem = ToDoItem(title: "First")
        itemManager!.addItem(firstItem)
        
        let secondItem = ToDoItem(title: "Second")
        itemManager!.addItem(secondItem)
        
        NSNotificationCenter.defaultCenter().postNotificationName(UIApplicationWillResignActiveNotification, object: nil)
        
        itemManager = nil
        
        XCTAssertNil(itemManager)
        
        itemManager = ItemManager()
        XCTAssertEqual(itemManager?.toDoCount, 2)
        XCTAssertEqual(itemManager?.itemAtIndex(0), firstItem)
        XCTAssertEqual(itemManager?.itemAtIndex(1), secondItem)
    }
}
