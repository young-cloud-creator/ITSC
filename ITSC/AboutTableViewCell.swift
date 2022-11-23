//
//  AboutTableViewCell.swift
//  ITSC
//
//  Created by Qingyun Yang on 2022/11/22.
//

import UIKit

class AboutTableViewCell: UITableViewCell {
    
    var title: UILabel = UILabel()
    var content: UILabel = UILabel()
    var desc: UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let stack = UIStackView(frame: self.contentView.frame)
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.addSubview(self.title)
        stack.addSubview(self.content)
        stack.addSubview(self.desc)
        
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.content.translatesAutoresizingMaskIntoConstraints = false
        self.desc.translatesAutoresizingMaskIntoConstraints = false
        
        self.title.topAnchor.constraint(equalTo: stack.topAnchor, constant: CGFloat(8)).isActive = true
        self.content.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: CGFloat(8)).isActive = true
        self.desc.topAnchor.constraint(equalTo: self.content.bottomAnchor, constant: CGFloat(8)).isActive = true
        
        self.title.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: CGFloat(8)).isActive = true
        self.content.leadingAnchor.constraint(equalTo: self.title.leadingAnchor).isActive = true
        self.desc.leadingAnchor.constraint(equalTo: self.title.leadingAnchor).isActive = true
        
        self.title.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: CGFloat(-8)).isActive = true
        self.content.trailingAnchor.constraint(equalTo: self.title.trailingAnchor).isActive = true
        self.desc.trailingAnchor.constraint(equalTo: self.title.trailingAnchor).isActive = true
        
        self.title.numberOfLines = 0
        self.title.textAlignment = NSTextAlignment.center
        self.title.font = UIFont.boldSystemFont(ofSize: CGFloat(18))
        self.content.numberOfLines = 0
        self.content.textAlignment = NSTextAlignment.center
        self.desc.numberOfLines = 0
        self.desc.textAlignment = NSTextAlignment.center
        
        self.contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
