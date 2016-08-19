//
//  ItemCellTests.swift
//  ToDo
//
//  Created by Yemi Ajibola on 8/8/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import XCTest
@testable import ToDo

extension ItemCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}

class ItemCellTests: XCTestCase {
    
    var controller:ItemListViewController!
    var tableView:UITableView!
    var fakeDataSource:FakeDataSource!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewControllerWithIdentifier("ItemListViewController") as! ItemListViewController
        _ = controller.view
        tableView = controller.tableView
        fakeDataSource = FakeDataSource()
        tableView.dataSource = fakeDataSource
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSUTHasNameLabel() {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ItemCell
        XCTAssertNotNil(cell.titleLabel)
    }
    
    func testSUTHasLocationLabel() {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ItemCell
        XCTAssertNotNil(cell.locationLabel)

    }
    
    func testSUTHasDateLabel() {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ItemCell
        XCTAssertNotNil(cell.dateLabel)
        
    }
    
    func testConfigWithItem_SetsLabelTexts() {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ItemCell
        cell.configCellWithItem(ToDoItem(title:"First", itemDescription: nil, timestamp: 1456150025, location: Location(name: "Home")))
        
        XCTAssertEqual(cell.titleLabel.text, "First")
        XCTAssertEqual(cell.locationLabel.text, "Home")
        XCTAssertEqual(cell.dateLabel.text, "02/22/2016")
    }
    
    func testTitle_ForCheckedTasks_IsStrokeThrough() {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ItemCell
        let toDoItem = ToDoItem(title:"First", itemDescription: nil, timestamp: 1456150025, location: Location(name: "Home"))
        cell.configCellWithItem(toDoItem, checked: true)
        
        let attributedString = NSAttributedString(string: "First", attributes: [NSStrikethroughStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue])
        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
        XCTAssertNil(cell.locationLabel.text)
        XCTAssertNil(cell.dateLabel.text)
    }
}
