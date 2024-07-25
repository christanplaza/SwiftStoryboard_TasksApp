//
//  ViewController.swift
//  Tasks
//
//  Created by Sun Asterisk Philippines on 7/24/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Get all current saved tasks
        self.title = "Tasks"
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        updateTasks()
    }
    
    func updateTasks() {
        tasks.removeAll()
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        for x in 0..<count {
            if let task = UserDefaults().value(forKey: "task_\(x + 1)") as? String {
                tasks.append(task)
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func didTapAdd() {
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteAndReindexTasks(from position: Int) {
        guard var count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        // Remove the task from UserDefaults
        UserDefaults().removeObject(forKey: "task_\(position + 1)")
        
        // Shift the subsequent tasks
        for i in (position + 1)..<count {
            if let nextTask = UserDefaults().value(forKey: "task_\(i + 1)") as? String {
                UserDefaults().setValue(nextTask, forKey: "task_\(i)")
            }
        }
        
        // Remove the last task since it has been shifted
        UserDefaults().removeObject(forKey: "task_\(count)")
        
        // Decrement the count
        count -= 1
        UserDefaults().setValue(count, forKey: "count")
        
        // Update the tasks array and table view
        updateTasks()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        vc.title = "Task Details"
        vc.task = tasks[indexPath.row]
        vc.currentPosition = indexPath.row
        vc.deleteTask = {
            self.deleteAndReindexTasks(from: indexPath.row)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row]
        
        return cell
    }
}
