import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

let realm = try! Realm()

var categoryList:Results<Category>?

override func viewDidLoad() {
    super.viewDidLoad()
    loadCategories()
    tableView.rowHeight = 80.0
    tableView.separatorStyle = .none
    
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    print("IndexPath for categoryList is \(indexPath.row)")
    
    if let category = categoryList?[indexPath.row]{
        cell.textLabel?.text = category.categoryName
        cell.backgroundColor = UIColor(hexString: category.cellColor)
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor, isFlat: true)
    } else{
        cell.textLabel?.text = "No categories added yet"
    }
    
    return cell
}

//TODO: - Add Category Button
@IBAction func addCategory(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Add new Category", message: "Add new cat", preferredStyle: .alert)
    var textField = UITextField()
    
    let addCategoryAction = UIAlertAction(title: "Add Category", style: .default){
        (action) in
        
        if let text = textField.text{
            if text != "" && text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) != "" {
                let category = Category()
                category.categoryName = text
                category.cellColor = UIColor.randomFlat()!.hexValue()
                self.save(category: category)
            }
            else{
                let warning = UIAlertController(title: "Error!", message: "Please add a category Name", preferredStyle: .alert)
                let warningAction = UIAlertAction(title: "Got it!", style: .cancel, handler: nil)
                warning.addAction(warningAction)
                self.present(warning, animated: true, completion: nil)
            }
        }
    }
    
    alert.addTextField
    {
        (displayTextField)in
        displayTextField.placeholder = "Enter new Category"
        textField = displayTextField
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(addCategoryAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
}

//MARK: - TableView Datasource Methods
override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryList?.count ?? 1
}


//MARK: - TableView Delegate Sources
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
    
    tableView.deselectRow(at: indexPath, animated: true)
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! ToDoTableViewController
    
    if let indexPath = tableView.indexPathForSelectedRow{
        destinationVC.setCategory = categoryList?[indexPath.row]
    }
}

//MARK: - Data Manipulation Methods

//TODO: - Add Load function
func loadCategories(){
    categoryList = realm.objects(Category.self)
}

//TODO: - Add Save function
func save(category: Category){
    do {
        try realm.write {
            realm.add(category)
        }
    }
    catch{
        print("Error saving. Error is \(error)")
    }
    tableView.reloadData()
}

//MARK: - Delete Methods from Swipe
override func updateModel(at indexPath: IndexPath) {
    super.updateModel(at: indexPath)
            if let selectedCategory = self.categoryList?[indexPath.row]{
                    do {
                        try self.realm.write {
                            self.realm.delete(selectedCategory)
                        }
                    }
                    catch{
                        print("Error deleting category")
                    }
                }
}

}
