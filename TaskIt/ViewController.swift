//
//  ViewController.swift
//  TaskIt
//
//  Created by User  on 2014-12-05.
//  Copyright (c) 2014 Wub.com. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext  = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    @IBOutlet weak var tableView: UITableView!
    //var taskArray:[TaskModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
       fetchedResultsController = getFetchedResultsController()
       fetchedResultsController.delegate = self
       fetchedResultsController.performFetch(nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        taskArray.sort{$0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970}
           }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showTaskDetail" {
        let detailVC: TaskDetailViewController = segue.destinationViewController as TaskDetailViewController
        let indexPath = self.tableView.indexPathForSelectedRow()
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath!) as TaskModel
        detailVC.detailTaskModel = thisTask
        
        }
        if segue.identifier == "showTaskAdd" {
            let addTaskVC: AddTaskViewController = segue.destinationViewController as AddTaskViewController
            
        }
    }

    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }
    
    //UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:TaskCell  = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskCell
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        
        cell.descriptionLabel.text = thisTask.subtask
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        cell.taskLabel.text = thisTask.task
        tableView.tableFooterView = UIView()//get rid of empty rows
        return cell
    }
    
    //UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    func  tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
//    fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: "completed", cacheName: nil)
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if fetchedResultsController.sections?.count == 1 {
            let fetchedObjects = fetchedResultsController.fetchedObjects!
            let testTask:TaskModel = fetchedObjects[0] as TaskModel
            if testTask.completed == true {
                return "Completed"
            }
            else {
                return "To do"
            }
        }
        else {
            if section == 0 {
                return "To do"
            }
            else {
                return "Completed"
            }
        }
    
    
    }
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 25
        }
        else {
            return 20
        }
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        
//        if (indexPath.section == 0 && isAllCompleted()) || (indexPath.section == 1){
//            thisTask.completed = false
//            
//        }
//        
//        else  {
//            thisTask.completed = true
//        }
        
        if thisTask.completed == true {
            thisTask.completed = false
        } else {
            thisTask.completed = true
        }
        
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()

        tableView.reloadData()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
       // var newTask = TaskModel(task: thisTask.task, subTask: thisTask.subtask, date: thisTask.date, completed: !thisTask.completed)
        var completeAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Complete", handler: { (tvra:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
           // self.baseArray[indexPath.section].removeAtIndex(indexPath.row)
            //self.baseArray[1].append(newTask)
           thisTask.completed = true
            self.tableView.reloadData()
        })
        completeAction.backgroundColor = UIColor.greenColor()
        
        
        var uncompleteAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Uncomplete", handler: { (tvra:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
         //  (fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel).deleted = true
           thisTask.completed = false

           // self.baseArray[indexPath.section].removeAtIndex(indexPath.row)
           // self.baseArray[0].append(newTask)
           self.tableView.reloadData()
        })
        
        uncompleteAction.backgroundColor = UIColor.redColor();
        
        
        if (indexPath.section == 0 && isAllCompleted()) || (indexPath.section == 1){
            return [uncompleteAction]
        }
        else
        {
                return [completeAction]
        }
    }
    
    //helper
    
    func taskFetchRequest() -> NSFetchRequest{
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completedDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        fetchRequest.sortDescriptors = [completedDescriptor,sortDescriptor]
        
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "completed", cacheName: nil)
        return fetchedResultsController
    }
    
    
//    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//    
//    println("Dir of Sales.sql is: \(urls)")
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var numberOfSection: Int
//        var headerView: UIView
//        headerView.drawRect(CGRectMake(0, 0, tableView.bounds.size.width, 30))
//        
//        if section == 0
//        {
//            headerView.backgroundColor = UIColor.greenColor()
//        }
//        else
//        {
//            headerView.backgroundColor = UIColor.blueColor()
//        }
//        return headerView
//    }

    //Helper functions
    
    func isAllCompleted() -> Bool {
        var ret:Bool = false
        if fetchedResultsController.sections!.count == 1 {
            if fetchedResultsController.sections![0].numberOfObjects > 0 {
                var indexPath = NSIndexPath(forItem: 0, inSection: 0)
                var task = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
                ret = task.completed.boolValue
            }
        }
        return ret
    }

}

