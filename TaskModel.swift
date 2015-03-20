//
//  TaskModel.swift
//  TaskIt
//
//  Created by User  on 2014-12-10.
//  Copyright (c) 2014 Wub.com. All rights reserved.
//

import Foundation
import CoreData

@objc(TaskModel)
class TaskModel: NSManagedObject {

    @NSManaged var completed: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var subtask: String
    @NSManaged var task: String

}
