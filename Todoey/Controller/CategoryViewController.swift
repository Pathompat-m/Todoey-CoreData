//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pathompat Mekbenchapivat on 5/4/2567 BE.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    // Array to store categories
    var categories = [Category]()
    
    // Accessing Core Data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Load categories when the view is loaded
    loadCategory()

    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Display category names in table view cells
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform segue when a category is selected
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass selected category to TodoListViewController
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory() {
        // Save category to Core Data
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // Reload table view data
        tableView.reloadData()
    }
    
    func loadCategory() {
        // Fetch categories from Core Data
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        // Reload table view data
        tableView.reloadData()
    }
    

    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Present an alert controller to add a new category
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (antion) in
            //What will happen once the user clicks the Add Item button on our UIAlert
            // Create a new category and save it
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            self.saveCategory()

        }
        
        alert.addTextField() { (alertTestField) in
            alertTestField.placeholder = "Create new category"
            textField = alertTestField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
}
