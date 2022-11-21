//
//  AnnouncementViewController.swift
//  ITSC
//
//  Created by Qingyun Yang on 2022/11/21.
//

import UIKit

class AnnouncementViewController: TableViewController {

    let baseUrl = "https://itsc.nju.edu.cn/tzgg/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.loadDataFromURL(baseURL: baseUrl)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "announcement", for: indexPath) as! NewsTableViewCell
        let listItem = listData[indexPath.row]
        cell.newsTitle?.text = listItem.title
        cell.newsDate?.text = listItem.date
        cell.href = listItem.href
        return cell
    }

}
