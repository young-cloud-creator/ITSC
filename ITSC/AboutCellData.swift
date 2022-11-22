//
//  AboutCell.swift
//  ITSC
//
//  Created by Qingyun Yang on 2022/11/22.
//

import UIKit

class AboutCellData: NSObject {
    let title: String
    let content: String
    let desc: String
    
    init(title: String, content: String, desc: String) {
        self.title = title
        self.content = content
        self.desc = desc
    }
}
