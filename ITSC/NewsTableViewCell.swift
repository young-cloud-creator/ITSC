//
//  NewsTableViewCell.swift
//  ITSC
//
//  Created by Qingyun Yang on 2022/11/21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    var href: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newsTitle.translatesAutoresizingMaskIntoConstraints = false
        newsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(16)).isActive = true
        newsTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(16)).isActive = true
        newsTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CGFloat(-16)).isActive = true
        newsTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CGFloat(0.6)).isActive = true
        newsDate.translatesAutoresizingMaskIntoConstraints = false
        newsDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: CGFloat(-16)).isActive = true
        newsDate.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(16)).isActive = true
        newsDate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CGFloat(-16)).isActive = true
        newsDate.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CGFloat(0.3)).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
