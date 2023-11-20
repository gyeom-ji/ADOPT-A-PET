//
//  MissingDetailViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/15.
//

import Foundation
import UIKit

extension MissingDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.missingM.missingNotice.id == -1 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell
        else {fatalError("no matched TableViewCell identifier")}
        let contentText = self.missingM.missingNotice.contentAtIndex(indexPath.row)
        print(contentText)
        
        if contentText == "*" {
            cell.title.font = .systemFont(ofSize: 14, weight: .medium)
            cell.content.text = ""
            cell.backGroundView.isHidden = false
            cell.title.tintColor = .systemBrown
        }
        else{
            cell.backGroundView.isHidden = true
            cell.title.font = .systemFont(ofSize: 12, weight: .medium)
            cell.content.isHidden = false
            cell.content?.text = contentText
            cell.title.tintColor = UIColor(red: 80/255, green: 69/255, blue: 56/255, alpha: 1)
        }
 
        cell.title?.text = self.missingM.missingNotice.titleAtIndex(indexPath.row)
        
        return cell
    }
}


class MissingDetailViewController: UIViewController{
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var missingMenuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    private var missingM = MissingNoticeModel.shared
    
    override func viewWillAppear(_ animated: Bool) {
       
        missingM.readMissingOne(id: missingM.missingNotice.id) {
            (result) in

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        if missingM.missingNotice.animal.isUrl != false {
            let url = URL(string: missingM.missingNotice.animal.img)
            imgView.load(url: url!)
        }
        swipeRecognizer()
        setupTableView()
        
        
        var menuItems: [UIAction] {
            return [
                UIAction(title: "작성자 전화연결", image: UIImage(systemName: "phone"), handler: { (_) in self.clickCalling()}),
                UIAction(title: "작성자 문자연결", image: UIImage(systemName: "message"), handler: { (_) in self.clickMessage()}),
                
            ]
        }
        var demoMenu: UIMenu{
            return UIMenu(image: nil, identifier: nil, options: [], children: menuItems )
        }
        self.missingMenuBtn.menu = demoMenu
        self.missingMenuBtn.showsMenuAsPrimaryAction = true
        
        let defaults = UserDefaults.standard
        
        if defaults.integer(forKey: "pk") == missingM.missingNotice.memberId{
        var menuItems2: [UIAction] {
            return [
                UIAction(title: "수정", image: UIImage(systemName: "pencil"), handler: { (_) in self.clickChangeBtn()}),
                UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in self.clickDeleteBtn()}),
                
            ]
        }
        var demoMenu2: UIMenu{
            return UIMenu(image: nil, identifier: nil, options: [], children: menuItems2 )
        }
        self.menuBtn.menu = demoMenu2
        self.menuBtn.showsMenuAsPrimaryAction = true
        }
        else{
            menuBtn.isHidden = true
        }
      
    }
    
    func clickChangeBtn(){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "MissingNoticeInsertViewController")as? MissingNoticeInsertViewController else {return}
        
        nextVC.hero.isEnabled = true
        nextVC.isChange = true
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        self.present(nextVC, animated: true, completion: nil)
    }
    
    func clickDeleteBtn(){
        missingM.deleteMissing(animalId:missingM.missingNotice.animal.id)
        self.dismiss(animated: true)
    }
    
    func clickCalling(){
     
        if let link = NSURL(string: "tel://"+missingM.missingNotice.phone),
           
           UIApplication.shared.canOpenURL(link as URL) {
            
            UIApplication.shared.open(link as URL, options: [:], completionHandler: nil)
        }
    }
    
    
    func clickMessage(){
        
        if let link = NSURL(string: "sms://"+missingM.missingNotice.phone),
           
           UIApplication.shared.canOpenURL(link as URL) {

            UIApplication.shared.open(link as URL, options: [:], completionHandler: nil)
        }
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func clickBactBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
