//
//  ViewController.swift
//  Smart Shopping 2
//
//  Created by Chris Turner on 30/08/2019.
//  Copyright © 2019 Coding From Scratch. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ListViewController: SwipeTableViewController {

    var allItems : Results<Item>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadItems()
        
    }

    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CustomItemCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
//        let cell = super.tableView.dequeueReusableCell(withIdentifier: "customItemCell", for: indexPath) as! CustomItemCell
        
        if let item = allItems?[indexPath.row] {
            cell.itemName?.text = item.title
            
            if item.meal == true {
                cell.itemType?.text = "Meal"
                cell.itemType.backgroundColor = .flatMagenta
            }
            if item.newlyAddedItem == true {
                cell.itemType?.text = "New"
                cell.itemType.backgroundColor = .flatGreen
            }
            if item.staple == true {
                cell.itemType?.text = "Staple"
                cell.itemType.backgroundColor = .flatOrange
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items Added"
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = allItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error toggling done status, \(error)")
            }

        tableView.deselectRow(at: indexPath, animated : false)
            
        tableView.reloadData()
    }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let item = allItems?[indexPath.row]
        
        if item?.meal == false {
            
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
    else {
    return nil
    }
    }
    //MARK - Add new Items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the Add Item button on the UI Alert
            print("add button pressed")
            
            
            do {
            try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.newlyAddedItem = true
                self.realm.add(newItem)
                }
        } catch {
            print("Error saving new items, \(error)")                }
            
    self.tableView.reloadData()
            
}
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    //MARK - Model manipulation methods

    func loadItems() {
        
        allItems = realm.objects(Item.self).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    
    }
    
    override func deleteItem(at indexPath : IndexPath) {
        if let itemForDeletion = self.allItems?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting meal, \(error)")
            }
        }
    }
    
    override func makeStaple(at indexPath : IndexPath) {
        if let itemForStaple = self.allItems?[indexPath.row] {
            
            do {
                try self.realm.write {
                    itemForStaple.newlyAddedItem = false
                    itemForStaple.staple = true
                }
            } catch {
                print("Error making staple, \(error)")
            }
        }
    }
}
    //MARK: - Search Bar Methods

extension ListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        allItems = allItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

