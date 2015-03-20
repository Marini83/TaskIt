//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by User  on 2014-12-06.
//  Copyright (c) 2014 Wub.com. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {

    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var subtaskTextField: UITextField!
   // @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var taskTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
  
    @IBAction func addTaskButtonTapped(sender: UIButton) {
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let managedObjectContext = appDelegate.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
        let task = TaskModel(entity:entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        task.task = taskTextField.text
        task.subtask = subtaskTextField.text
        task.date = dueDatePicker.date
        task.completed = false
        
        appDelegate.saveContext()
        var request = NSFetchRequest(entityName: "TaskModel")
        var error:NSError? = nil
        
        var results:NSArray = managedObjectContext!.executeFetchRequest(request, error: &error)!
        
        for res in results{
            println(res)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
