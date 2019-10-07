import UIKit
import RealmSwift
import ChameleonFramework

class ToDoTableViewController: SwipeTableViewController {

    var toDoItems:Results<Item>?
    let realm = try! Realm()
    
    var setCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.itemName
            cell.accessoryType = item.isDone ? .checkmark : .none
            cell.backgroundColor = doGradientColor(color: UIColor.flatSkyBlue(), index: indexPath.row)
            //UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor, isFlat: true)
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor, isFlat: true)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //What happens when you click on the add Button on NavBar
    @IBAction func AddButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Add Button clicked")
            
                if let text = textField.text{
                    if text != "" && text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) != ""{
                        if let currentCategory = self.setCategory{
                            do{
                                try self.realm.write{
                                    let newItem = Item()
                                    newItem.itemName = text
                                    newItem.dateCreated = Date()
                                    //newItem.cellColor = self.doGradientColor(color: UIColor.flatSkyBlue())//UIColor.randomFlat()!.hexValue()
                                    currentCategory.items.append(newItem)
                                    self.tableView.reloadData()
                                }
                            }
                            catch{
                                print("Error saving item")
                            }
                        }
                    }
                    else{
                        let warning = UIAlertController(title: "Error!", message: "Cannot add an empty title", preferredStyle: .alert)
                        let warningAction = UIAlertAction(title: "Got it!", style: .cancel, handler: nil)
                        warning.addAction(warningAction)
                        self.present(warning, animated: true, completion: nil)
                    }
                }
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
        toDoItems = setCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        if let selectedItem = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(selectedItem)
                }
            }
            catch{
                print("Error occured while trying to delete item")
            }
        }
    }
    
    func doGradientColor(color: UIColor, index: Int) -> UIColor{
        let gradValue: CGFloat = CGFloat(CGFloat(index)/CGFloat(toDoItems!.count))
        print("Gradient Value is \(gradValue)")
        return color.darken(byPercentage: gradValue)!
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
