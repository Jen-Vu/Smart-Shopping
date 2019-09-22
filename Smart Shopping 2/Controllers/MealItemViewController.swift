//
//  MealItemViewController.swift
//  Smart Shopping 2
//
//  Created by Chris Turner on 16/09/2019.
//  Copyright © 2019 Coding From Scratch. All rights reserved.
//

import UIKit
import RealmSwift

class MealItemViewController: SwipeTableViewController {
    
    var mealItems : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedMeal : Meal? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CustomItemCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = mealItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items Added"
        }
       
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //        context.delete(itemArray[indexPath.row])
        //
        //        itemArray.remove(at: indexPath.row)
        
////        itemArray[indexPath.row].done = mealItems[indexPath.row].done
//
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated : true)
        
    }
    
    //MARK - Add new Items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the Add Item button on the UI Alert
            
            if let currentMeal = self.selectedMeal {
                
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.meal = true
                    currentMeal.items.append(newItem)
                }
                } catch {
                    print("Error saving new items, \(error)")                }
            }
            
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

        mealItems = selectedMeal?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func deleteItem(at indexPath : IndexPath) {
        if let itemForDeletion = self.mealItems?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting meal, \(error)")
            }
        }
    }
    
    


}

