//
//  TableViewController.swift
//  ITSC
//
//  Created by Qingyun Yang on 2022/11/21.
//

import UIKit

class TableViewController: UITableViewController {

    var listData: [CellData] = [CellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! NewsTableViewCell
        // Configure the cell...
        //cell.newsTitle
        //cell.newsDate
        //cell.href
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let contentViewController = segue.destination as! ContentViewController
        let cell = sender as! NewsTableViewCell
        contentViewController.href = cell.href
    }
    
    func loadDataFromURL(baseURL: String) {
        if let url = URL(string: baseURL+"list.htm") {
            let task = URLSession.shared.dataTask(with: url, completionHandler: {
                data, response, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("server error")
                    return
                }
                if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                   let data = data,
                   let string = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.loadHtml(html: string)
                    }
                }
            })
            task.resume()
            
        }
        
        for pageIdx in 2..<50 {
            if let url = URL(string: baseURL+"list"+String(pageIdx)+".htm") {
                let task = URLSession.shared.dataTask(with: url, completionHandler: {
                    data, response, error in
                    if let error = error {
                        print("\(error.localizedDescription)")
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        print("server error")
                        return
                    }
                    if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                       let data = data,
                       let string = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            self.loadHtml(html: string)
                        }
                    }
                })
                task.resume()
            }
        }
    }
    
    func loadHtml(html: String) {
        do {
            let white = try NSRegularExpression(pattern: "[\\v\\f\\t\\n\\r]")
            let noWhite = white.stringByReplacingMatches(in: html, range: NSRange(location: 0, length: html.count), withTemplate: "")
            
            let listReg = try NSRegularExpression(pattern: "<ul class=\"news_list list2\">(.*?)</ul>")
            let matches = listReg.matches(in: noWhite, range: NSRange(location: 0, length: noWhite.count))
            
            for itemList in matches {
                let li = (noWhite as NSString).substring(with: itemList.range)
                loadList(li: li)
            }
            self.tableView.reloadData()
        }
        catch {
            print(error.localizedDescription)
            return
        }
    }
    
    func loadList(li: String) {
        do {
            let itemReg = try NSRegularExpression(pattern: "<span class=\"news_title\">(.*?)</span><span class=\"news_meta\">(.*?)</span>")
            let matches = itemReg.matches(in: li, range: NSRange(location: 0, length: li.count))
            
            for item in matches {
                let i = (li as NSString).substring(with: item.range)
                try loadItem(item: i)
            }
        }
        catch {
            print(error.localizedDescription)
            return
        }
    }
    
    func loadItem(item: String) throws {
        let captureReg = try NSRegularExpression(pattern: "<span class=\"news_title\"><a href='(.*?)' target='_blank' title='(.*?)'>(.*?)</a></span><span class=\"news_meta\">(.*?)</span>")
        let matches = captureReg.matches(in: item, range: NSRange(location: 0, length: item.count))
        for i in matches {
            let hrefRange = i.range(at: 1)
            let href = (item as NSString).substring(with: hrefRange)
            let titleRange = i.range(at: 2)
            let title = (item as NSString).substring(with: titleRange)
            let dateRange = i.range(at: 4)
            let date = (item as NSString).substring(with: dateRange)
            self.listData.append(CellData(title: title, date: date, href: href))
        }
    }
    
    func date2int(date: String) -> Int {
        var result: String = date
        result.removeAll(where: {(c: Character)->Bool in c == Character("-")})
        return Int(result) ?? 0
    }

}
