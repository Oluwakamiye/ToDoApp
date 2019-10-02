//
//  ToDoTableViewController.swift
//  Todoey
//
//  Created by Oluwakamiye Akindele on 09/09/2019.
//  Copyright © 2019 Oluwakamiye Akindele. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoTableViewController: UITableViewController {

    var toDoItems:Results<Item>?
    let realm = try! Realm()
    
    var setCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    //Displaying items on the tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath)
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.itemName
            cell.accessoryType = item.isDone ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Items Added Yet"
        }
        return cell
    }

    //What happens when you select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItem = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    selectedItem.isDone = !selectedItem.isDone
                    tableView.reloadData()
                }
            }
            catch{
                print("Error updating item")
            }
        }
//        if let item = toDoItems?[indexPath.row]{
//            item.isDone = !item.isDone
//            saveItems()
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //What happens when you click on the add Button on NavBar
    @IBAction func AddButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Add Button clicked")
            if let currentCategory = self.setCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.itemName = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch{
                    print("Error saving item")
                }
            }
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(item: Item){
        print("Save Items Called")
        do{
            try realm.write {
                print("Inside Try")
                realm.add(item)
            }
        } catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
        toDoItems = setCategory?.items.sorted(byKeyPath: "itemName", ascending: true)
//        tableView.reloadData()
   }
}


//MARK: - Search Bar Methods
extension ToDoTableViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)
        toDoItems = toDoItems?.filter(predicate).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else{
            let predicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)
            loadItems()
            toDoItems = toDoItems?.filter(predicate).sorted(byKeyPath: "itemName", ascending: true)
            tableView.reloadData()
        }
    }
    
}
