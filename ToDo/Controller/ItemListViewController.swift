//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Yemi Ajibola on 8/4/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: protocol<UITableViewDataSource, UITableViewDelegate, ItemManagerSettable>!
    let itemManager = ItemManager()
    
    override func viewDidLoad() {
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        
        dataProvider.itemManager = itemManager
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showDetails:", name: "ItemSelectedNotification", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    func showDetails(sender:NSNotification) {
        guard let index = sender.userInfo?["index"] as? Int else { fatalError() }
        
        if let nextViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController {
            nextViewController.itemInfo = (itemManager, index)
            navigationController?.pushViewController(nextViewController, animated: true)
        }
       
        
    }
    
    
    @IBAction func addItem(sender: UIBarButtonItem) {
        if let nextViewController = storyboard?.instantiateViewControllerWithIdentifier("InputViewController") as? InputViewController {
            presentViewController(nextViewController, animated: true, completion: nil)
            nextViewController.itemManager = itemManager
        }
    }

}
