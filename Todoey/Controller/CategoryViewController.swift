//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 推進 dx on 2020/09/05.
//  Copyright © 2020 DX推進. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category_Todoey]()
    
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int{
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",
                                                 for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    
    //MARK: - Data Manipulate Methods
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print("Error saving category\(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
        let request : NSFetchRequest<Category_Todoey> = Category_Todoey.fetchRequest()
        
        do{
            categories = try context.fetch(request)
        }catch{
            print("Error loading categories\(error)")
        }
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default){ (action) in
            
            let newCategory = Category_Todoey(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        
        alert.addTextField{ (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            //TodoListViewControllerで記載(selectedCategory)
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }

}
