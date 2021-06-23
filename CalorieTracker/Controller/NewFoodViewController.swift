//
//  NewFoodViewController.swift
//  CalorieTracker
//
//  Created by Josue Rosales on 6/22/21.
//

import UIKit
import CoreData

class NewFoodViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var qtyTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        nameTextField.delegate = self
        caloriesTextField.delegate = self
        qtyTextField.delegate = self
    }

    @IBAction func savePressed(_ sender: UIButton) {
        if nameTextField.text != "" && caloriesTextField.text != "" && qtyTextField.text != "" {
            activeTextField.resignFirstResponder()
            context.performAndWait {
                let newFood = Food(context: context)
                newFood.name = nameTextField.text
                newFood.calories = (caloriesTextField.text! as NSString).floatValue
                
                let newEntry = Entry(context: context)
                newEntry.food = newFood
                newEntry.qty = (qtyTextField.text! as NSString).floatValue
                
                try! context.save()
            }
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

//MARK: - UITextField Delegate
extension NewFoodViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.resignFirstResponder()
            return true
        }
        
        return false
    }
    
    @objc func dismissKeyboard() {
        activeTextField.resignFirstResponder()
    }
}
