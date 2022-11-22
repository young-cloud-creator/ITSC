//
//  AboutTableViewCell.swift
//  ITSC
//
//  Created by Qingyun Yang on 2022/11/22.
//

import UIKit

class AboutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
