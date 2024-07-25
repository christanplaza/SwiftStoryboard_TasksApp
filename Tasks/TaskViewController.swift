//
//  TaskViewController.swift
//  Tasks
//
//  Created by Sun Asterisk Philippines on 7/24/24.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet var label: UILabel!
    
    var task: String?
    var currentPosition: Int?
    var deleteTask: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = task
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTaskAction))
    }
    
    @objc func deleteTaskAction() {
        guard let deleteTask = deleteTask else { return }
        deleteTask()
        navigationController?.popViewController(animated: true)
    }
}
