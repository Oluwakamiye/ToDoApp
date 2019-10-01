//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Oluwakamiye Akindele on 25/09/2019.
//  Copyright © 2019 Oluwakamiye Akindele. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryList = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadItems()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row].name
        return cell
    }
    
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Category", message: "Add new cat", preferredStyle: .alert)
        var textField = UITextField()
        
        let catAction = UIAlertAction(title: "Add Category", style: .default){
            (action) in
            
            let text = textField.text
            let category = Category(context: self.context)
            category.name = text
            
            self.categoryList.append(category)
            self.saveCategories()
        }
        
        alert.addTextField
        {
            (displayTextField)in
            displayTextField.placeholder = "Enter new Category"
            textField = displayTextField
        }
        
        alert.addAction(catAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    
    //MARK: - TableView Delegate Sources
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.setCategory = categoryList[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    //TODO: - Add Load function
    func loadItems(withCategory request:NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            try categoryList = context.fetch(request)
        }
        catch{
            print("Error loading data. Error is \(error)")
        }
        tableView.reloadData()
    }
    
    //TODO: - Add Save function
    func saveCategories(){
        do {
            try context.save()
            tableView.reloadData()
        }
        catch{
            print("Error saving. Error is \(error)")
        }
    }
    
}
