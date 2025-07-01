//
//  ViewController.swift
//  ToDoList
//
//  Created by Philips on 24/06/25.
//

import UIKit
import os
import CoreData

///This first screen you see when the app launches. This is where you see all tasks and this is the starting point for adding or editing a task. Tasks can only be deleted from here.
class HomeViewController: UIViewController {
    
    @IBOutlet weak var titleDate: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingsButton: UIButton!
    
    var tasks: [TaskModel] = []
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    
    //We create the button programatically because we cannot add the button as a subview of a tableview in the interface builder
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.link
        button.tintColor = UIColor.white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        
        //We change the scale of the imageview to make the size of the plus image bigger.
        button.imageView?.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.4)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNotifications()
        tasks = fetchTasks()
    }
    
    private func setupView(){
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
    }
    
    /// We setup observers to watch for notifications when a new task is created or when a task is edited
    private func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(createTask(_: )), name: Notification.Name("com.philipsUIKitTraining.createTask"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editTask(_: )), name: Notification.Name("com.philipsUIKitTraining.editTask"), object: nil)
    }
    
    func fetchTasks() -> [TaskModel] {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext

        // 1. Create a fetch request for the Task entity
        let fetchRequest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()

        // Optional: Add a sort descriptor
        // let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        // fetchRequest.sortDescriptors = [sortDescriptor]

        // Optional: Add a predicate (filter)
        // let predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
        // fetchRequest.predicate = predicate

        do {
            // 2. Execute the fetch request
            let tasks = try managedContext.fetch(fetchRequest)
            print("Fetched \(tasks.count) tasks.")
            for task in tasks {
                print("  - \(task.caption)")
            }
            return tasks
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    /**
     This responds to a task that has been created from the NewTaskViewController. The notification object holds a userInfo Object with the task that need to be updated.
     - Parameters:
        - notification: The notification object from the com.philipsUIKitTraining.createTask notification
     */
    @objc func createTask(_ notification: Notification){
        os_log("Task received by notification observer - create task", type: .info)
        guard let userInfo = notification.userInfo,
              let task = userInfo["newTask"] as? TaskModel else {
            return
        }
        tasks.append(task)
        tableView.reloadData()
        os_log("Task successfully created", type: .info)

    }
    
    /**
     This responds to a task that has been edited from the NewTaskViewController. The notification object holds a userInfo Object with the task that need to be updated.
     - Parameters:
        - notification: The notification object from the com.philipsUIKitTraining.editTask notification
     */
    @objc func editTask(_ notification: Notification){
        os_log("Task received by notification observer - edit task", type: .info)
   
        tasks = fetchTasks()
        tableView.reloadData()
        os_log("Task successfully edited", type: .info)
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
        addButton.pulseAnimation()
        let newTaskViewController = NewTaskViewController()
        present(newTaskViewController, animated: true)
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        settingsButton.pulseAnimation()
        performSegue(withIdentifier: "SettingsSegue", sender: nil)
        
    }
    
}

//MARK: - Methods conforming to UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
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
            let task = tasks[indexPath.row]
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            managedContext.delete(task)
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            tasks = fetchTasks()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


//MARK: - Methods conforming to TaskTableViewCellDelegate
extension HomeViewController: TaskTableViewCellDelegate {
    func editTask(task: TaskModel) {
        
        let newTaskViewController = NewTaskViewController(task: task)
        present(newTaskViewController, animated: true)
        
    }
    
    func markTask(task: TaskModel, complete: Bool) {
        
        task.isComplete = complete
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        tasks = fetchTasks()
        tableView.reloadData()
    }
}
