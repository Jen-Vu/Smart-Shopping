//
//  CustomItemCell.swift
//  Smart Shopping 2
//
//  Created by Chris Turner on 21/09/2019.
//  Copyright © 2019 Coding From Scratch. All rights reserved.
//

import UIKit
import SwipeCellKit

class CustomItemCell: SwipeTableViewCell {

    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemType: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        itemType.layer.masksToBounds = true
        itemType.layer.cornerRadius = 5
    }
    
}
