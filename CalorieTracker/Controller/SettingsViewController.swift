//
//  SettingsViewController.swift
//  CalorieTracker
//
//  Created by Josue Rosales on 6/22/21.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        let currentText = textField.text
        if currentText != "" && (currentText! as NSString).floatValue > 0 {
            UserDefaults.standard.setValue((currentText! as NSString).floatValue, forKey: "goalCalories")
            dismiss(animated: true, completion: nil)
        }
    }
}

//MARK - UITextfield Delegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.resignFirstResponder()
            return true
        }
        
        return false
    }
    
    @objc func dismissKeyboard() {
        textField.resignFirstResponder()
    }
}
