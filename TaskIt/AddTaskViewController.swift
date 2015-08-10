//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by User  on 2014-12-06.
//  Copyright (c) 2014 Wub.com. All rights reserved.
//

import UIKit
import CoreData

protocol AddTaskViewControllerDelegate {
    func addTask(message: String)
    func addTaskCanceled(message: String)
}

class AddTaskViewController: UIViewController {

    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var taskTextField: UITextField!
    
    var delegate: AddTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)

        taskTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // completion means run extra code when transitioning
    @IBAction func cancelButtonTapped(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.addTaskCanceled("Task was not added!")

        
    }
  
    @IBAction func addTaskButtonTapped(sender: UIButton) {
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let managedObjectContext = ModelManager.instance.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
        let task = TaskModel(entity:entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey) == true {
            task.task = taskTextField.text.capitalizedString
        } else {
            task.task = taskTextField.text

        }
        
        task.subtask = subtaskTextField.text
        task.date = dueDatePicker.date
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == true {
            task.completed = true
        } else {
            task.completed = false
        }
        
        
        ModelManager.instance.saveContext()
        var request = NSFetchRequest(entityName: "TaskModel")
        var error:NSError? = nil
        
        var results:NSArray = managedObjectContext!.executeFetchRequest(request, error: &error)!
        
        for res in results{
            println(res)
        }
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.addTask("task Added")

    }

}
