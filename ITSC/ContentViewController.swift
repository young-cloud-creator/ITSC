//
//  ContentViewController.swift
//  ITSC
//
//  Created by Qingyun Yang on 2022/11/21.
//

import UIKit

class ContentViewController: UIViewController {

    var href: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.titleLabel.text = "内容不知道跑哪里去了🥺"
        self.loadPage()
    }
    
    func loadPage() {
        if let url = URL(string: self.href) {
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
            
            let pageReg = try NSRegularExpression(pattern: "<h1 class=[\"\']arti_title[\"\']>(.*?)</h1>(.*?)<p class=[\"\']arti_metas[\"\']><span class=[\"\']arti_update[\"\']>(.*?)</span>(.*?)</p>(.*?)<div class=[\"\']entry[\"\']>(.*?)<div class=[\"\']read[\"\']><div class=[\"\']wp_articlecontent[\"\']>(.*?)</div>")
            let matches = pageReg.matches(in: noWhite, range: NSRange(location: 0, length: noWhite.count))
            if !matches.isEmpty {
                let titleRange = matches[0].range(at: 1)
                let dateRange = matches[0].range(at: 3)
                let contentRange = matches[0].range(at: 7)
                var title = (noWhite as NSString).substring(with: titleRange)
                var date = (noWhite as NSString).substring(with: dateRange)
                let content = (noWhite as NSString).substring(with: contentRange)
                
                try processHtmlChar(string: &title)
                try processHtmlChar(string: &date)
                self.titleLabel.text = title
                self.dateLabel.text = date
                try loadContent(content: content)
            }
        }
        catch {
            print(error.localizedDescription)
            return
        }
    }
    
    func processHtmlChar(string: inout String) throws {
        let htmlQuoteReg = try NSRegularExpression(pattern: "&quot;")
        let htmlAndReg = try NSRegularExpression(pattern: "&amp;")
        let htmlGreaterReg = try NSRegularExpression(pattern: "&gt;")
        let htmlLessReg = try NSRegularExpression(pattern: "&lt;")
        let htmlSpaceReg = try NSRegularExpression(pattern: "&nbsp;")
        let htmlAposReg = try NSRegularExpression(pattern: "&apos;")
        string = htmlQuoteReg.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: "\"")
        string = htmlAndReg.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: "&")
        string = htmlGreaterReg.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: ">")
        string = htmlLessReg.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: "<")
        string = htmlSpaceReg.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: " ")
        string = htmlAposReg.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: "\'")
    }
    
    func loadContent(content: String) throws {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
