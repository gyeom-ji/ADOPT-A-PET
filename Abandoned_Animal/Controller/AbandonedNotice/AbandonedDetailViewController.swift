//
//  AbandonedDetailViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/14.
//

import Foundation
import UIKit

extension AbandonedDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.abandonedM.abandonedNotice.id == -1 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell
        else {fatalError("no matched TableViewCell identifier")}
        
        let notice = self.abandonedM.abandonedNotice
        let contentText = notice.contentAtIndex(indexPath.row)
        
        let attrString = NSMutableAttributedString(string: contentText)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        
        if contentText == "*" {
            cell.title.font = .systemFont(ofSize: 14, weight: .medium)
            cell.title.textColor = UIColor(red: 183/255, green: 169/255, blue: 154/255, alpha: 1)
            cell.content.text = ""
            cell.backGroundView.isHidden = false
        }
        else if indexPath.row == (notice.id == -1 ? 0 : 1) {
            cell.content.lineBreakMode = .byWordWrapping
            cell.backGroundView.isHidden = true
            cell.content.attributedText = attrString
        }
        
        else{
            cell.backGroundView.isHidden = true
            cell.title.font = .systemFont(ofSize: 12, weight: .medium)
            cell.content.text = contentText
        }
        
        cell.title?.text =  notice.titleAtIndex(indexPath.row)
        cell.title.sizeToFit()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
}


class AbandonedDetailViewController: UIViewController{
    
    @IBOutlet weak var formInsertBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    
    private let abandonedM = AbandonedNoticeModel.shared
    
    var cellHeights: [IndexPath: CGFloat] = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        abandonedM.readAbandonedOne(id: self.abandonedM.abandonedNotice.id) {
            DispatchQueue.main.async {
                if self.abandonedM.abandonedNotice.animal.isUrl == true {
                    let url = URL(string: self.abandonedM.abandonedNotice.animal.img)
                    self.imgView.load(url: url!)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeRecognizer()
        setupTableView()
        
        let defaults = UserDefaults.standard
        
        if defaults.integer(forKey: "userType") != 2 {
            formInsertBtn.isHidden = true
        }
        else{
            formInsertBtn.isHidden = false
        }
        if defaults.integer(forKey: "shelterPk") == abandonedM.abandonedNotice.shelter.id {
            
            var menuItems: [UIAction] {
                return [
                    UIAction(title: "수정", image: UIImage(systemName: "pencil"), handler: { (_) in self.clickChangeBtn()}),
                    UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in self.clickDeleteBtn()}),
                ]
            }
            var demoMenu: UIMenu{
                return UIMenu(image: nil, identifier: nil, options: [], children: menuItems )
            }
            self.menuBtn.menu = demoMenu
            self.menuBtn.showsMenuAsPrimaryAction = true
        }
        else{
            menuBtn.isHidden = true
        }
    }
    
    func clickChangeBtn(){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "AbandonedNoticeInsertViewController")as? AbandonedNoticeInsertViewController else {return}
        
        nextVC.hero.isEnabled = true
        nextVC.isChange = true
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        self.present(nextVC, animated: true, completion: nil)
    }
    
    func clickDeleteBtn(){
        abandonedM.deleteAbandoned()
        self.dismiss(animated: true)
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func clickBactBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickFormInsertBtn(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "FormInsertViewController")as? FormInsertViewController else {return}
        self.present(nextVC, animated: true, completion: nil)
    }
}
