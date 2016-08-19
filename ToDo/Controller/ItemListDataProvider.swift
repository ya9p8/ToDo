//
//  ItemListDataProvider.swift
//  ToDo
//
//  Created by Yemi Ajibola on 8/4/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit

enum Section: Int {
    case ToDo
    case Done
}

@objc protocol ItemManagerSettable {
    var itemManager: ItemManager? { get set }
}

class ItemListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate, ItemManagerSettable {
    
    var itemManager:ItemManager?
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let itemManager = itemManager else { return 0 }
        guard let itemSection = Section(rawValue: section) else {
            fatalError()
        }
        
        let numberOfRows: Int
    
        switch itemSection {
        case .ToDo:
            numberOfRows = itemManager.toDoCount
        case .Done:
            numberOfRows = itemManager.doneCount
        }
        
        return numberOfRows
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        guard let itemManager = itemManager else { fatalError() }
        guard let section = Section(rawValue: indexPath.section) else
        {
            fatalError()
        }
        
        let item: ToDoItem
        switch(section) {
        case .ToDo:
            item = itemManager.itemAtIndex(indexPath.row)
        case .Done:
            item = itemManager.doneItemAtIndex(indexPath.row)
        }
        
        cell.configCellWithItem(item)
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        guard let section = Section(rawValue: indexPath.section) else
        {
            fatalError()
        }
        let buttonTitle: String
        switch section {
        case .ToDo:
            buttonTitle =  "Check"
        case .Done:
            buttonTitle = "Uncheck"
        }
        
        return buttonTitle
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let section = Section(rawValue: indexPath.section) else
        {
            fatalError()
        }
        switch section {
        case .ToDo:
          itemManager?.checkItemAtIndex(indexPath.row)
        case .Done:
            itemManager?.uncheckItemAtIndex(indexPath.row)
        }
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let itemSection = Section(rawValue: indexPath.section) else { fatalError() }
        
        switch itemSection {
        case .ToDo:
            NSNotificationCenter.defaultCenter().postNotificationName("ItemSelectedNotification", object: self, userInfo: ["index": indexPath.row])
        default:
            break
        }
        
    }
}
