//
//  ViewController.swift
//  Todoey
//
//  Created by DX推進 on 2020/07/29.
//  Copyright © 2020 DX推進. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    //ItemClassを使用する
    var itemArray = [Item]()
    
    var selectedCategory : Category_Todoey? {
        didSet{
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    //CoreDataにアクセス？
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                
        //CRUD - Read
        loadItems()
    }
    
    
    //MARK: - Tableview Datasource Methoda ~~~~~~~~~~~~~~~~~~~~
    
    //初めから起動
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //要素数分リストを表示する
        return itemArray.count
    }
    
    //初めから起動
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        //表示するテキストを決定する
        //ItemClassの場合、タイトルを使用する
        cell.textLabel?.text = item.title
        
        //チェックマークの操作
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods ~~~~~~~~~~~~~~~~~~~~
    
    //選択すると起動する
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //CRUD - Update
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        //CRUD - Delete
        //※contextから先に消す（itemArrayのrowで場所を指示するため、数か変わってしまう）
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        //選択するとチェックマークが切り替わる
        //現在の選択と逆のものが適応される（trueならfalse）
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //CRUD - Create
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items ~~~~~~~~~~~~~~~~~~~~
    
    //CRUD - Create
    //押すと反応する
    @IBAction func addButtonPrePressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
                
        //ボタンを押した後のアクション
        let action = UIAlertAction(title: "Add Item", style: .default){
            //what will happen once the user clicks the Add Item button on our UIAlert
            (action) in
            
            //AppDelegateにアクセスするための呪文
            let newItem = Item(context: self.context)
            
            //not optional だから設定が必要
            newItem.title = textField.text!
            newItem.done = false
            
            //Set category
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            //CRUD - Create
            self.saveItems()
        }
        
        //テキスト記入欄作成
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
            //print(alertTextField.text)
        }
        
        alert.addAction(action)
        
        //アラート表示
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - Model manupulation Methods
    
    //CRUD - Create
    func saveItems() {
        do {
            try context.save()
        }catch{
            print("Error saving context\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //CRUD - Read
    // もしrequestパラメータが無ければ、Item.fetchRequestを適応する
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        //カテゴリーのラベル
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@",
                                    selectedCategory!.name!)
        //サーチバーのラベル
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
        itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}


//MARK: - Search Bar methods

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        //検索欄のバツボタンをクリックで全て表示
        if searchBar.text?.count == 0{
            loadItems()
            
            //非同期処理
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
