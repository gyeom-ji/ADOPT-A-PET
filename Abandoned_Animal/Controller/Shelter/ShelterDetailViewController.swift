//
//  ShelterDetailViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/16.
//
import Foundation
import UIKit

extension ShelterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.shelterM.shelter.id == -1 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell
        else {fatalError("no matched TableViewCell identifier")}
        let contentText = self.shelterM.shelter.contentAtIndex(indexPath.row)
        print(contentText)
        
        cell.title.font = .systemFont(ofSize: 12, weight: .medium)
        cell.content.isHidden = false
        cell.content?.text = contentText
        
        cell.title?.text = self.shelterM.shelter.titleAtIndex(indexPath.row)
        
        return cell
    }
}


class ShelterDetailViewController: UIViewController{
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    private var shelterM =  ShelterModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if defaults.integer(forKey: "userType") == 0 {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "보호소 계정 생성", image: UIImage(systemName: "person.badge.plus"), handler: { (_) in self.clickInsertStaffBtn()}),
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
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        let num = Int.random(in: 0...2)
        
        imgView.image = UIImage(named: num == 0 ? "dog-2" : num == 1 ? "cat" : "rabbit")
        swipeRecognizer()
        setupTableView()
    }
    
    func clickInsertStaffBtn(){
        insertStaff(id: shelterM.shelter.id)
    }
    
    func clickDeleteBtn(){
        shelterM.deleteShelter(id: shelterM.shelter.id)
        self.dismiss(animated: true)
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    @IBAction func clickCallBtn(_ sender: UIButton) {
        
        if let link = NSURL(string: "tel://"+shelterM.shelter.phone),
           
            UIApplication.shared.canOpenURL(link as URL) {
            
            //사용가능한 URLScheme이라면 open(_:options:completionHandler:) 메소드를 호출해서
            //만들어둔 URL 인스턴스를 열어줍니다.
            UIApplication.shared.open(link as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func clickBactBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension ShelterDetailViewController{
    
    func insertStaff(id: Int){
        AdminModel.shared.insertStaff(shelterId: id){
            response in
            if response  == true {
                
                let alert = UIAlertController(title: "", message: "보호소 계정 생성 완료", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default){
                    (action) in
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "보호소 계정 생성 실패", message: "다시 시도해주세요.", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default){
                    (action) in
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
