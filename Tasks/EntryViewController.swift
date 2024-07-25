//
//  EntryViewController.swift
//  Tasks
//
//  Created by Sun Asterisk Philippines on 7/24/24.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add a Task"
        
        field.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        
        return true
    }
    
    @objc func saveTask() {
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        let newCount = count + 1
        
        // Adding the number of tasks
        UserDefaults().set(newCount, forKey: "count")
        
        // Saving the actual Task
        UserDefaults().set(text, forKey:"task_\(newCount)")
        
        update?()
        
        navigationController?.popViewController(animated: true)
    }
}
