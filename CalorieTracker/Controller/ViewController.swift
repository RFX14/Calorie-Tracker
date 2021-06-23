//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Josue Rosales on 6/22/21.
//

import UIKit
import CoreData
import SwiftUI

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let reuseIdentifier = "collectionCell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var entries: [NSManagedObject] = []
    var progress: CGFloat = 0 {
        didSet {
            let userInfo: [String: CGFloat] = ["progress": self.progress]
            NotificationCenter.default.post(Notification(name: .progress, object: nil, userInfo: userInfo))
        }
    }
    
    var isFirstLaunch: Bool {
        if UserDefaults.standard.bool(forKey: "onBoarded") {
            return false
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        fetchEntries()
        loadSwiftUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstLaunch {
            UserDefaults.standard.setValue(true, forKey: "onBoarded")
            UserDefaults.standard.setValue(1800, forKey: "goalCalories")
            performSegue(withIdentifier: "toSettings", sender: nil)
        }
        fetchEntries()
    }
    
    func loadSwiftUI() {
        let controller = UIHostingController(rootView: ProgressView())
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
        
        controller.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 115).isActive = true
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        controller.view.layer.masksToBounds = false
    }
    
    func fetchEntries() {
        DispatchQueue.main.async {
            self.context.performAndWait {
                self.entries = try! self.context.fetch(Entry.fetchRequest())
                self.entries.reverse()
            }
            let goalCalories = UserDefaults.standard.float(forKey: "goalCalories")
            var currentCalories: Float = 0
            for currentEntry in self.entries {
                let currentFood = currentEntry.value(forKey: "Food") as! Food
                let calories = currentFood.value(forKey: "calories") as! Float
                let qty = currentEntry.value(forKey: "qty") as! Float
                
                currentCalories += calories * qty
            }
            self.progress = CGFloat(currentCalories / goalCalories)
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionView Delegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        let currentEntry = entries[indexPath.row]
        let currentFood = currentEntry.value(forKey: "Food") as! Food
        let calories = currentFood.value(forKey: "calories") as! Float
        let qty = currentEntry.value(forKey: "qty") as! Float
        
        cell.nameLabel.text = currentFood.value(forKey: "name") as? String
        cell.qtyLabel.text = "x\(qty.clean)"
        cell.caloriesLabel.text = "\((calories * qty).clean)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 310, height: 75)
    }
}
