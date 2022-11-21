//
//  InfomationViewController.swift
//  ITSC
//
//  Created by Qingyun Yang on 2022/11/21.
//

import UIKit

class InformationViewController: TableViewController {

    let baseUrl = "https://itsc.nju.edu.cn/wlyxqk/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.loadDataFromURL(baseURL: baseUrl)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "information", for: indexPath) as! NewsTableViewCell
        cell.newsTitle?.text = listData[indexPath.row].title
        cell.newsDate?.text = listData[indexPath.row].date
        cell.href = listData[indexPath.row].href
        return cell
    }
    
}
