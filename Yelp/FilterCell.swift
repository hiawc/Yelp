//
//  FilterCell.swift
//  Yelp
//
//  Created by Nhat Truong on 3/16/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterCellDelegate{
    optional func filterCell(filterCell: FilterCell, didChangeValue value:Bool)
}

class FilterCell: UITableViewCell {
        
    

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    weak var delegate: FilterCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        onSwitch.addTarget(self, action: "switchValueChange", forControlEvents: UIControlEvents.ValueChanged)
      

        
    }

       
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChange(){
        delegate?.filterCell?(self, didChangeValue: onSwitch.on)
    }
   }
