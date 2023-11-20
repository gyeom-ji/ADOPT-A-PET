//
//  FormDetailViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/21.
//

import Foundation
import UIKit

extension FormDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 22
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.formM.form.id == -1 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell
        else {fatalError("no matched TableViewCell identifier")}
        
        let contentText = self.formM.form.contentAtIndex(indexPath.row)
        
        //행간 조절
        let attrString = NSMutableAttributedString(string: contentText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        
        cell.title?.text = self.formM.form.titleAtIndex(indexPath.row)
        cell.title.sizeToFit()
        
        if contentText == "*" {
            cell.title.font = .systemFont(ofSize: 14, weight: .medium)
            cell.title.textColor = UIColor(red: 183/255, green: 169/255, blue: 154/255, alpha: 1)
            cell.content.text = ""
            cell.backGroundView.isHidden = false
            
        }
        else if indexPath.row == (self.formM.form.id == -1 ? 0 : 1) {
            cell.content.lineBreakMode = .byWordWrapping
            cell.backGroundView.isHidden = true
            cell.content.attributedText = attrString
        }
        else{
            cell.backGroundView.isHidden = true
            cell.title.font = .systemFont(ofSize: 12, weight: .medium)
            cell.content.attributedText = attrString
        }
        
        return cell
    }
}


class FormDetailViewController: UIViewController{
    private var formM = FormModel.shared
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var formLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var userType = Int()
    
    override func viewWillAppear(_ animated: Bool) {
        
        formM.readFormOne(id: formM.form.id){
            (value) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        self.userType = defaults.integer(forKey: "userType")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        let form = formM.form
        if form.abandoned.animal.isUrl != false {
            let url = URL(string: (form.abandoned.animal.img))
            imgView.load(url: url!)
        }
        formLabel.text = form.type + " : " + form.approval
        
        var menuItems: [UIAction] {
            if userType == 2 {
                if form.approval == "검토중" {
                    return [
                        UIAction(title:"수정", image: UIImage(systemName:  "pencil"), handler: { (_) in self.clickChangeBtn()}),
                        UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in self.clickDeleteBtn()}),
                    ]
                }
                else{
                    return [
                        UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in self.clickDeleteBtn()}),
                    ]
                }
            }
            else{
                return [
                    UIAction(title:"승인" , image: UIImage(systemName: "checkmark.circle"), handler: { (_) in self.clickApprovalBtn()}),
                    UIAction(title: "거절" , image: UIImage(systemName: "xmark.circle"), attributes: .destructive, handler: { (_) in self.clickRejectBtn()}),
                ]
            }
        }
        var demoMenu: UIMenu{
            return UIMenu(image: nil, identifier: nil, options: [], children: menuItems )
        }
        self.menuBtn.menu = demoMenu
        self.menuBtn.showsMenuAsPrimaryAction = true
        
        swipeRecognizer()
        setupTableView()
    }
    
    func clickApprovalBtn(){
        formApproval(approval: "승인")
    }
    
    func clickRejectBtn(){
        formApproval(approval: "거부")
    }
    
    func clickChangeBtn(){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "FormInsertViewController")as? FormInsertViewController else {return}
        nextVC.isChange = true
        self.present(nextVC, animated: true, completion: nil)
    }
    
    func clickDeleteBtn(){
        formM.deleteForm()
        self.dismiss(animated: true)
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func clickCallBtn(_ sender: UIButton) {
        
        let phone = formM.form.abandoned.shelter.phone
        if let link = NSURL(string: "tel://" + phone),
           
            UIApplication.shared.canOpenURL(link as URL) {
            
            //사용가능한 URLScheme이라면 open(_:options:completionHandler:) 메소드를 호출해서
            //만들어둔 URL 인스턴스를 열어줍니다.
            UIApplication.shared.open(link as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func clickBactBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func setAlarm(str: String){
        let alert = UIAlertController(title: "", message: str, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default){
            (action) in
        }
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension FormDetailViewController{
    
    func formApproval(approval: String){
        formM.formApproval(approval: approval) { response in
            if response == true {
                DispatchQueue.main.async {
                    self.formLabel.text = self.formM.form.type + " : " + self.formM.form.approval
                }
            }
            else{
                self.setAlarm(str: "다시 시도해주세요.")
            }
        }
    }
}

