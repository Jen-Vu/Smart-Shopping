//
//  SwipeTableViewController.swift
//  Smart Shopping 2
//
//  Created by Chris Turner on 18/09/2019.
//  Copyright © 2019 Coding From Scratch. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CustomItemCell", bundle: nil), forCellReuseIdentifier: "customItemCell")
    }
    
    //TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CustomItemCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customItemCell", for: indexPath) as! CustomItemCell
                
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        if orientation == .right {
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            print("Delete Cell")
            
            self.deleteItem(at: indexPath)

        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    else {
            let stapleAction = SwipeAction(style: .default, title: "Staple") { action, indexPath in
                // handle action by updating model with deletion
                
                print("Make Staple")
                
                self.makeStaple(at: indexPath)
                
            }
            
            // customize the action appearance
            stapleAction.image = UIImage(named: "delete-icon")
            stapleAction.backgroundColor = UIColor.flatOrange
            return [stapleAction]
    }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        if orientation == .right {
        options.expansionStyle = .destructive
        return options
        }
        else {
            options.expansionStyle = .selection
            return options
        }
    }

    func deleteItem(at indexPath : IndexPath) {
        //Delete an item
        
    }
    
    func makeStaple(at indexPath : IndexPath) {
        
        //make something a staple
    }
    
}
