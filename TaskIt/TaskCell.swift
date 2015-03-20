//
//  TaskCell.swift
//  TaskIt
//
//  Created by User  on 2014-12-05.
//  Copyright (c) 2014 Wub.com. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
