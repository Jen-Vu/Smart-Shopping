//
//  MealViewController.swift
//  Smart Shopping 2
//
//  Created by Chris Turner on 16/09/2019.
//  Copyright © 2019 Coding From Scratch. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class MealViewController: UITableViewController {

    let realm = try! Realm()
    
    var meals : Results<Meal>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMeals()

    }
    
    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meals?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath)
        
        cell.textLabel?.text = meals?[indexPath.row].name ?? "No Meals Added Yet"
        
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
