//
//  MealViewController.swift
//  Smart Shopping 2
//
//  Created by Chris Turner on 16/09/2019.
//  Copyright © 2019 Coding From Scratch. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class MealViewController: SwipeTableViewController {
    
    var meals : Results<Meal>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMeals()
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none

    }
    
    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meals?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
        cell.textLabel?.text = meals?[indexPath.row].name ?? "No Meals Added Yet"
        
        cell.backgroundColor = UIColor.randomFlat
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(meal: Meal) {
        do {
            try realm.write {
                realm.add(meal)
            }
            } catch {
            print("Error saving meal \(error)")
        }
        tableView.reloadData()
    }
    
    func loadMeals() {
        
        meals = realm.objects(Meal.self)
        
        tableView.reloadData()
    }
    
    //MARK - Delete Data from Swipe
    
    override func updateModel(at indexPath : IndexPath) {
            if let mealForDeletion = self.meals?[indexPath.row] {

                do {
                    try self.realm.write {
                        self.realm.delete(mealForDeletion)
                    }
                } catch {
                    print("Error deleting meal, \(error)")
                }
            }
    }

   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Meal", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let addedMeal = Meal()
            addedMeal.name = textField.text!
            
            self.save(meal: addedMeal)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new meal"
        }
        
        present(alert, animated : true, completion: nil)
        
        
    }
    
    //MARK : - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MealItemViewController
        
        if  let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedMeal = meals?[indexPath.row]
        }
    }
    
}

//MARK: - Search Bar Methods

extension MealViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        meals = meals?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)

        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadMeals()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

