//
//  ViewController.swift
//  Smart Shopping 2
//
//  Created by Chris Turner on 30/08/2019.
//  Copyright © 2019 Coding From Scratch. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UITableViewController {

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        
        if let item = allItems?[indexPath.row] {
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

//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
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
            print("add button pressed")
            
            
            do {
            try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
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
        
        allItems = realm.objects(Item.self)
        
        tableView.reloadData()
        
    }

//MARK: - Search Bar Methods

//extension ListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)
//
//        print("search request")
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
//
//}
}
