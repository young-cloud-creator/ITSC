//
//  CellData.swift
//  ITSC
//
//  Created by Qingyun Yang on 2022/11/21.
//

import UIKit

class CellData: NSObject {
    let title: String
    let date: String
    let href: String
    
    init(title: String, date: String, href: String) {
        self.title = title
        self.date = date
        self.href = href
    }
}
