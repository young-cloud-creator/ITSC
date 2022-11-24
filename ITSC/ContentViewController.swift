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
        self.titleLabel.text = "加载中..."
        self.loadPage()
    }
    
    func loadPage() {
        if self.href.contains("redirect") {
            self.titleLabel.text = "页面似乎在尝试重定向，已停止继续加载"
        }
        else if let url = URL(string: self.href) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: {
                data, response, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.titleLabel.text = "内容不知道跑哪里去了🥺"
                    }
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("server error")
                    DispatchQueue.main.async {
                        self.titleLabel.text = "内容不知道跑哪里去了🥺"
                    }
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
            
            let pageReg = try NSRegularExpression(pattern: "<h1 class=[\"\']arti_title[\"\']>(.*?)</h1>(.*?)<p class=[\"\']arti_metas[\"\']><span class=[\"\']arti_update[\"\']>(.*?)</span>(.*?)</p>(.*?)<div class=[\"\']entry[\"\']>(.*?)<div class=[\"\']read[\"\']>(<div class=[\"\']wp_articlecontent[\"\']>)?(.*?)</div>")
            let matches = pageReg.matches(in: noWhite, range: NSRange(location: 0, length: noWhite.count))
            if !matches.isEmpty {
                let titleRange = matches[0].range(at: 1)
                let dateRange = matches[0].range(at: 3)
                let contentRange = matches[0].range(at: 8)
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
        let htmlBrReg = try NSRegularExpression(pattern: "<br />")
        string = htmlQuoteReg.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: "\"")
        string = htmlAndReg.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: "&")
        string = htmlGreaterReg.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: ">")
        string = htmlLessReg.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: "<")
        string = htmlSpaceReg.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: " ")
        string = htmlAposReg.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: "\'")
        string = htmlBrReg.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: "\n")
    }
    
    func loadContent(content: String) throws {
        let paragraphReg = try NSRegularExpression(pattern: "<((p>)|(section>)|(p (.*?)>)|(section (.*?)>))(.*?)</((p)|(section))>")
        let matches = paragraphReg.matches(in: content, range: NSRange(location: 0, length: content.count))
        let mutableString = NSMutableAttributedString()
        for p in matches {
            let paraRange = p.range(at: 8)
            mutableString.insert(try loadPara(paragraph: (content as NSString).substring(with: paraRange)), at: mutableString.length)
            mutableString.insert(NSAttributedString(string: "\n\n"), at: mutableString.length)
        }
        self.contentText.attributedText = mutableString
        self.contentText.font = UIFont(name: "System Font Regular", size: 18.0)
    }
    
    func loadPara(paragraph par: String) throws -> NSMutableAttributedString {
        var para = par
        try processHtmlChar(string: &para)
        let imgReg = try NSRegularExpression(pattern: "<img(.*?) src=[\"\'](.*?)[\"\']")
        let matches = imgReg.matches(in: para, range: NSRange(location: 0, length: para.count))
        let mutableString = NSMutableAttributedString()
        if matches.isEmpty {
            let tagReg = try NSRegularExpression(pattern: "<(.*?)>")
            let noTag = tagReg.stringByReplacingMatches(in: para, range: NSRange(location: 0, length: para.count), withTemplate: "")
            mutableString.insert(NSAttributedString(string: noTag), at: mutableString.length)
        }
        else {
            for img in matches {
                let imgSrcRange = img.range(at: 2)
                var imgSrc = (para as NSString).substring(with: imgSrcRange)
                if !imgSrc.contains("https://") {
                    imgSrc = "https://itsc.nju.edu.cn"+imgSrc
                }
                do {
                    let data = try Data(contentsOf: URL(string: imgSrc)!)
                    let tmpImg = UIImage(data: data)
                    let img = UIImage(data: data, scale: 1.03*(Double((tmpImg?.size.width)!)/Double((self.contentText?.frame.width)!)))
                    let attachment = NSTextAttachment(image: img!)
                    let string = NSAttributedString(attachment: attachment)
                    mutableString.insert(string, at: mutableString.length)
                }
                catch {
                    print(error.localizedDescription)
                    continue
                }
            }
        }
        return mutableString
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
