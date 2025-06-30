//
//  ViewController.swift
//  ToDoList
//
//  Created by Philips on 24/06/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleDate: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var tasks: [Task] = []
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.link
        button.tintColor = UIColor.white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.4)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleDate.text = dateFormatter.string(from: Date())
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 24
        titleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        view.addSubview(addButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(createTask(_: )), name: Notification.Name("com.philipsUIKitTraining.createTask"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editTask(_: )), name: Notification.Name("com.philipsUIKitTraining.editTask"), object: nil)
    }
    
    @objc func createTask(_ notification: Notification){
        guard let userInfo = notification.userInfo,
              let task = userInfo["newTask"] as? Task else {
            return
        }
        tasks.append(task)
        tableView.reloadData()
    }
    
    @objc func editTask(_ notification: Notification){
        guard let userInfo = notification.userInfo,
              let taskToUpdate = userInfo["updateTask"] as? Task else {
            return
        }
        let taskIndex = tasks.firstIndex { task in
            task.id == taskToUpdate.id
        }
        guard let taskIndex else {
            return
        }
        
        tasks[taskIndex] = taskToUpdate
        tableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //print(view.safeAreaInsets.bottom)
        let safeAreaBottom = view.safeAreaInsets.bottom
        let width: CGFloat = 60
        let height: CGFloat = 60
        let xPos = view.frame.width / 2 - width / 2
        let yPos = view.frame.height - height - safeAreaBottom
        addButton.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        addButton.layer.cornerRadius = addButton.frame.width / 2
    }
    @objc func addButtonTapped() {
        let newTaskViewController = NewTaskViewController()
        present(newTaskViewController, animated: true)
    }
    @IBAction func settingsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "SettingsSegue", sender: nil)
        
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        cell.configure(withTask: task, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}



extension ViewController: TaskTableViewCellDelegate {
    func editTask(id: String) {
        let task = tasks.first { task in
            task.id == id
        }
        guard let task = task else {
            return
        }
        
        let newTaskViewController = NewTaskViewController(task: task)
        present(newTaskViewController, animated: true)
        
    }
    
    func markTask(id: String, complete: Bool) {
        let taskIndex = tasks.firstIndex { task in
            task.id == id
        }
        guard let taskIndex = taskIndex else {
            return
        }
        tasks[taskIndex].isComplete = complete
        tableView.reloadData()
    }
}
