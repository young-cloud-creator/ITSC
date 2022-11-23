//
//  AboutTableViewController.swift
//  ITSC
//
//  Created by Qingyun Yang on 2022/11/22.
//

import UIKit

class AboutTableViewController: UITableViewController {

    let aboutURL = "https://itsc.nju.edu.cn/main.htm"
    var aboutInfo: [AboutCellData] = [AboutCellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInfo()
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
        return aboutInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "about", for: indexPath) as! AboutTableViewCell

        // Configure the cell...
        cell.title.text = aboutInfo[indexPath.row].title
        cell.content.text = aboutInfo[indexPath.row].content
        cell.desc.text = aboutInfo[indexPath.row].desc

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func loadInfo() {
        if let url = URL(string: self.aboutURL) {
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
    
    func loadHtml(html: String) {
        do {
            let white = try NSRegularExpression(pattern: "[\\v\\f\\t\\n\\r]")
            let noWhite = white.stringByReplacingMatches(in: html, range: NSRange(location: 0, length: html.count), withTemplate: "")
            
            let infoReg = try NSRegularExpression(pattern: "<div class=\"tt\"><h3 class=\"tit\"><span class=\"title\">关于我们</span> </h3></div><div class=\"con\"><div id=\"wp_news_w91\"> <ul class=\"news_list clearfix\">(.*?)</ul></div> </div>")
            let matches = infoReg.matches(in: noWhite, range: NSRange(location: 0, length: noWhite.count))
            let infoListRange = matches[0].range(at: 1)
            let infoList = (noWhite as NSString).substring(with: infoListRange)
            try self.loadList(list: infoList)
            self.tableView.reloadData()
        }
        catch {
            print(error.localizedDescription)
            return
        }
    }
    
    func loadList(list: String) throws {
        let htmlQuoteReg = try NSRegularExpression(pattern: "&quot;")
        let htmlAposReg = try NSRegularExpression(pattern: "&apos;")
        let itemReg = try NSRegularExpression(pattern: "<div class=\"news_box\"><div class=\"news_title\"><(.*?)>(.*?)<(.*?)></div><div class=\"news_fbt\">(.*?)</div><div class=\"news_text\">(.*?)</div></div>")
        let matches = itemReg.matches(in: list, range: NSRange(location: 0, length: list.count))
        for item in matches {
            let titleRange = item.range(at: 2)
            let contentRange = item.range(at: 4)
            let descriptionRange = item.range(at: 5)
            
            var title = (list as NSString).substring(with: titleRange)
            var content = (list as NSString).substring(with: contentRange)
            var desc = (list as NSString).substring(with: descriptionRange)
            
            title = htmlQuoteReg.stringByReplacingMatches(in: title, range: NSRange(location: 0, length: title.count), withTemplate: "\"")
            title = htmlAposReg.stringByReplacingMatches(in: title, range: NSRange(location: 0, length: title.count), withTemplate: "\'")
            content = htmlQuoteReg.stringByReplacingMatches(in: content, range: NSRange(location: 0, length: content.count), withTemplate: "\"")
            content = htmlAposReg.stringByReplacingMatches(in: content, range: NSRange(location: 0, length: content.count), withTemplate: "\'")
            desc = htmlQuoteReg.stringByReplacingMatches(in: desc, range: NSRange(location: 0, length: desc.count), withTemplate: "\"")
            desc = htmlAposReg.stringByReplacingMatches(in: desc, range: NSRange(location: 0, length: desc.count), withTemplate: "\'")
            
            aboutInfo.append(AboutCellData(title: title, content: content, desc: desc))
        }
    }
}
