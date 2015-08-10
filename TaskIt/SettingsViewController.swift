//
//  SettingsViewController.swift
//  TaskIt
//
//  Created by User  on 2015-03-22.
//  Copyright (c) 2015 Wub.com. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var capitalizeTableView: UITableView!
    @IBOutlet weak var completeNewTodoTableView: UITableView!
    @IBOutlet weak var versionLabel: UILabel!
  
    let kVersionNumber = "1.0"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)

        self.capitalizeTableView.dataSource = self;
        self.capitalizeTableView.delegate = self;
        self.capitalizeTableView.scrollEnabled = false;
        
        self.completeNewTodoTableView.dataSource = self;
        self.completeNewTodoTableView.delegate = self;
        self.completeNewTodoTableView.scrollEnabled = false;
        
        self.title = "Settings";
        //You can also set the version label to match the bundle version (set in the General tab of the target) by using:
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
        let build = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String
        switch (version, build) {
        case let (.Some(version), .Some(build)):
            self.versionLabel.text = "\(version).\(build)"
        default:
            self.versionLabel.text = "??"
        }
        
        //self.versionLabel.text = kVersionNumber
        // change the title of the back button manually instead of it being "back" by default or you could use image asset
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneBarButtonItemPressed:"))
        // we get access to navigatioItem for free because we segued by using Push
        self.navigationItem.leftBarButtonItem = doneButton
        
        
        // Do any additional setup after loading the view.
    }
//it's common to pass the object when related to UIElements. This is useful if you have multiple UIElements hooked up to the same IBAction
    func doneBarButtonItemPressed(barButtonItem: UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /* 
func setUITableViewCellAccessoryTypeForKey(key: String, whenKeyEqualsBool bool: Bool) -> UITableViewCellAccessoryType {

if NSUserDefaults.standardUserDefaults().boolForKey(key) == bool {

return UITableViewCellAccessoryType.Checkmark

} else {

return UITableViewCellAccessoryType.None

}

}
*/

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.capitalizeTableView {
            var capitalizeCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("capitalizeCell") as! UITableViewCell
            
            if indexPath.row == 0 {
                capitalizeCell.textLabel?.text = "No do not Capitalize"
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey) == false{
                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.None
                }// if nsuserdefaults
            }// if indexpath.row == 0
            else {
                capitalizeCell.textLabel?.text = "Yes Capitalize!"
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey) == true{
                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.None
                }// if nsuserdefaults
            }
            return capitalizeCell
        }// capitalizeTableView
        else {
            var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("completeNewTodoCell") as! UITableViewCell
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "Do not complete Task"
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == false {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            }// if indexPath.row == 0
            else {
                cell.textLabel?.text = "Complete Task"
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == true {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            return cell
        }
        
    }
    func  tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.capitalizeTableView {
            return "Capitalize new Task?"
        }
        else {
            return "Complete new Task?"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.capitalizeTableView {
            if indexPath.row == 0 {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: kShouldCapitalizeTaskKey)
            }
            else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kShouldCapitalizeTaskKey)
            }
        }
        else {
            if indexPath.row == 0 {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: kShouldCompleteNewTodoKey)
            }
            else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kShouldCompleteNewTodoKey)
            }
        }
        NSUserDefaults.standardUserDefaults().synchronize()
        tableView.reloadData()
    }
    
}
