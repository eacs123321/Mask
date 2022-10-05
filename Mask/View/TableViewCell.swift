//
//  TableViewCell.swift
//  Mask
//
//  Created by 何安竺 on 2022/10/5.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var pharmacyLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var adultLabel: UILabel!
    @IBOutlet weak var childLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pharmacyLabel.textColor = TDefind.s_textColor
        areaLabel.textColor = TDefind.s_textColor
        adultLabel.textColor = TDefind.s_textColor
        childLabel.textColor = TDefind.s_textColor
        self.backgroundColor = TDefind.s_tablebackGroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
