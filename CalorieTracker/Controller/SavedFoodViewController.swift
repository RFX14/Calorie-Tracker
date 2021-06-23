//
//  SavedFoodViewController.swift
//  CalorieTracker
//
//  Created by Josue Rosales on 6/22/21.
//

import UIKit
import CoreData

class SavedFoodViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var foods: [NSManagedObject] = []
    
    let reusableCell = "tableCell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: reusableCell)
        fetchEntries()
    }
    
    func fetchEntries() {
        DispatchQueue.main.async {
            self.context.performAndWait {
                self.foods = try! self.context.fetch(Food.fetchRequest())
                self.foods.reverse()
            }
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate
extension SavedFoodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCell, for: indexPath) as! TableViewCell
        let currentFood = foods[indexPath.row] as! Food
        
        cell.nameLabel.text = currentFood.name!
        cell.caloriesLabel.text = String(currentFood.calories)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Enter Quantity", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Quantity"
            textField.keyboardType = .decimalPad
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let qty = alert.textFields?.first?.text {
                self.context.performAndWait {
                    let newEntry = Entry(context: self.context)
                    newEntry.food = (self.foods[indexPath.row] as! Food)
                    newEntry.qty = (qty as NSString).floatValue
                    
                    try! self.context.save()
                }
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
}
