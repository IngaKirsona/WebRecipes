//
//  ListTableViewController.swift
//  WebRecipes
//
//  Created by Inga Kirsona on 12/09/2020.
//  Copyright © 2020 Inga Kirsona. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {
    var recipes = [Recipe]()
    
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDeleggate = UIApplication.shared.delegate as! AppDelegate
        context = appDeleggate.persistentContainer.viewContext
        loadData()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        addNewRecipe()
    }
    
func addNewRecipe(){
        let alertController = UIAlertController(title: "Recipe!", message: "Do you want to add a new recipe?", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            //-------> what will be seen fairly in add cell, when nothing is typed
            textField.placeholder = "Enter the web page of your recipe"
        }
        //-------> to add webpage
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            let textField = alertController.textFields?.first
            let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: self.context!)
            let recipe = NSManagedObject(entity: entity!, insertInto: self.context)
            //-------> to add text to item
            recipe.setValue(textField?.text, forKey: "webPage")
            //-------> to save text to Recipe
            self.saveData()
            //-------> need to load because it reloads tableview
            self.loadData()
        }//end addAction
        //-------> to add cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    //-------> to fetch and reload a tableview
    func loadData(){
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do{
            let result = try context?.fetch(request)
            recipes = result!
        }catch{
            fatalError(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func saveData(){
        do {
            try self.context?.save()
        }catch{
            fatalError(error.localizedDescription)
        }
        loadData()
    }
    
    //-------> count the rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    //-------> cell formatting
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "webCell", for: indexPath)
        let recipe = recipes[indexPath.row]
        cell.textLabel?.text = recipe.value(forKey: "webPage") as? String
        cell.selectionStyle = .none
        // cell.textLabel?.text = recipesList[indexPath.row]
        //-------> to allow rows as many needed
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    //-------> when clicked on row, navigate to webViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //-------> to access vebWieController and asign passedValue to recipiesList
        let vc: WebViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.passedValue = recipes[indexPath.row].webPage!
        self.present(vc, animated: true)
    }
    
    //-------> to add delete option and alert
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Are you sure you want to delete?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
                self.context?.delete(self.recipes[indexPath.row])
                UIView.transition(with: tableView, duration: 1.0, options: .transitionCurlUp, animations: {
                    self.loadData()
                    self.saveData()
                }, completion: nil)
            }))
            self.present(alert, animated: true)}
    }
}
