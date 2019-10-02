import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryList:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategories()
    }

    //TODO: - Display categories as text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryList?[indexPath.row].categoryName ?? "No categories added yet"
        return cell
    }
    
    //TODO: - Add Category Button
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Category", message: "Add new cat", preferredStyle: .alert)
        var textField = UITextField()
        
        let catAction = UIAlertAction(title: "Add Category", style: .default){
            (action) in
            
            if let text = textField.text{
                let category = Category()
                category.categoryName = text
                
                self.save(category: category)
            }
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
    
}
