//
//  MypageViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation
import UIKit

extension MypageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 작성 공고
        if menuSeg.selectedSegmentIndex == 0 {
            if userType == 1 {
                return self.abandonedM.abandonedNoticeList.count
            }
            
            else {
                return self.missingM.missingNoticeList.count
            }
        }
        
        // 입양/임시보호 신청서
        return self.formM.formList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if menuSeg.selectedSegmentIndex == 0 {
            if userType == 1 {
                return self.abandonedM.abandonedNoticeList.count == 0 ? 0 : 1
            }
            else{
                return self.missingM.missingNoticeList.count == 0 ? 0 : 1
            }
        }
        return self.formM.formList.count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTableViewCell", for: indexPath) as? FormTableViewCell
        else {fatalError("no matched TableViewCell identifier")}
        
        print("menu", menuSeg.selectedSegmentIndex)
        if menuSeg.selectedSegmentIndex == 0 {
            if userType == 1 {
                let notice = self.abandonedM.abandonedNoticeList[indexPath.row]
                
                cell.firstTitle?.text = "공고번호 :"
                cell.firstContent?.text = notice.noticeNum
                cell.secondTitle?.text = "품종 :"
                cell.secondContent?.text = notice.animal.breed
                cell.thirdTitle?.text = "성별 :"
                cell.thirdContent?.text = notice.animal.sex
                cell.fourthTitle?.text = "공고기간 :"
                cell.fourthContent?.text = notice.period
                cell.fifthTitle.isHidden = true
                cell.fifthContent.isHidden = true
                if notice.animal.isUrl == true {
                    let url = URL(string: notice.animal.img)
                    cell.imgView.load(url: url!)
                }
            }
            else{
                let notice = self.missingM.missingNoticeList[indexPath.row]
                
                cell.fifthTitle.isHidden = false
                cell.fifthContent.isHidden = false
                
                cell.firstTitle?.text = "이름 :"
                cell.firstContent?.text = notice.animalName
                cell.secondTitle?.text = "품종 :"
                cell.secondContent?.text = notice.animal.breed
                cell.thirdTitle?.text = "성별 :"
                cell.thirdContent?.text = notice.animal.sex
                cell.fourthTitle?.text = "분실날짜 :"
                cell.fourthContent?.text = notice.date
                cell.fifthTitle?.text = "분실장소 :"
                cell.fifthContent?.text = notice.place
                
                if notice.animal.isUrl == true {
                    let url = URL(string: notice.animal.img)
                    cell.imgView.load(url: url!)
                }
            }
        }
        else{
            
            let notice = self.formM.formList[indexPath.row]
            
            cell.fifthTitle.isHidden = false
            cell.fifthContent.isHidden = false
            
            cell.firstTitle?.text = "신청유형 :"
            cell.firstContent?.text = notice.type
            cell.secondTitle?.text = "승인여부 :"
            cell.secondContent?.text = notice.approval
            cell.thirdTitle?.text = "공고번호 :"
            cell.thirdContent?.text = notice.abandoned.noticeNum
            cell.fourthTitle?.text = "품종 :"
            cell.fourthContent?.text = notice.abandoned.animal.breed
            cell.fifthTitle?.text = "성별 :"
            cell.fifthContent?.text = notice.abandoned.animal.sex
            
            if notice.abandoned.animal.isUrl == true {
                let url = URL(string: (notice.abandoned.animal.img))
                cell.imgView.load(url: url!)
            }
        }
        cell.imgView.layer.cornerRadius = cell.imgView.frame.height/2
        cell.imgView.layer.borderWidth = 3
        cell.imgView.layer.borderColor = UIColor.beige?.cgColor
        cell.imgView.clipsToBounds = true
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndex =
            tableView.indexPathForSelectedRow?.row {
            
            if menuSeg.selectedSegmentIndex == 0 {
                if userType == 1 {
                    guard let nextVC = self.storyboard?.instantiateViewController(identifier: "AbandonedDetailViewController")as? AbandonedDetailViewController else {return}
                    abandonedM.abandonedNotice.id = abandonedM.abandonedNoticeList[selectedIndex].id
                    nextVC.hero.isEnabled = true
                    nextVC.modalPresentationStyle = .fullScreen
                    nextVC.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
                    self.present(nextVC, animated: true, completion: nil)
                }
                else{
                    guard let nextVC = self.storyboard?.instantiateViewController(identifier: "MissingDetailViewController")as? MissingDetailViewController else {return}
                    missingM.missingNotice.id = missingM.missingNoticeList[selectedIndex].id
                    nextVC.hero.isEnabled = true
                    nextVC.modalPresentationStyle = .fullScreen
                    nextVC.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
                    self.present(nextVC, animated: true, completion: nil)
                }
            }
            else {
                guard let nextVC = self.storyboard?.instantiateViewController(identifier: "FormDetailViewController")as? FormDetailViewController else {return}
                formM.form.id = formM.formList[selectedIndex].id
                nextVC.hero.isEnabled = true
                nextVC.modalPresentationStyle = .fullScreen
                nextVC.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
                self.present(nextVC, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if  offsetY > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            
            if !isPaging {
                beginPaging()
            }
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

class MypageViewController: UIViewController{
    private var missingM = MissingNoticeModel.shared
    private var abandonedM = AbandonedNoticeModel.shared
    private var formM = FormModel.shared
    
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuSeg: UISegmentedControl!
    @IBOutlet weak var underLine: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var userType = Int() // 0 - admin 1 - shelter 2 - member
    var userPk = Int()
    var shelterPk = Int()
    var pageNum : Int = 0
    var isPaging: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ///set UsertDefaults
        let defaults = UserDefaults.standard
        self.userType = defaults.integer(forKey: "userType")
        print("userType = \(userType)")
        self.nameLabel.text = defaults.string(forKey: "name")
        self.userPk = defaults.integer(forKey: "pk")
        self.shelterPk = defaults.integer(forKey: "shelterPk")
        
        if userType == 0 {
            tableView.isHidden = true
            menuSeg.isHidden = true
            settingBtn.isHidden = true
        }
        else{
            tableView.isHidden = false
            menuSeg.isHidden = false
            settingBtn.isHidden = false
        }
        
        ///menuSegment Custom
        let backgroundImage = UIImage()
        
        self.menuSeg.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.menuSeg.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.menuSeg.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        
        let deviderImage = UIImage()
        self.menuSeg.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.menuSeg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.menuSeg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBrown, .font: UIFont.systemFont(ofSize: 13, weight: .semibold)], for: .selected)
        
        ///set TableView
        setupTableView()
        
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        ///set Segment UnderLine Animation
        DispatchQueue.main.async {
            if self.menuSeg.selectedSegmentIndex == 1 {
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        self.underLine.frame.origin.x = self.underLine.frame.maxX
                    }
                )
            }
            else {
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        self.underLine.frame.origin.x = 0
                    }
                )
            }
            self.setUp()
            
        }
    }
    private func setUp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            if self.menuSeg.selectedSegmentIndex == 0 {
                if self.userType == 1{ // 보호소 직원 유기공고 전체조회
                    self.readAbandonedNotice(Id: self.userPk)
                }
                else { //일반회원 실종공고
                    self.readMissingNotice(Id: self.userPk)
                }
            }
            else{ //신청서
                if self.userType == 1{ // 보호소 직원 신청서
                    self.readFormList(str:"/form/selectByStaff/\(self.shelterPk)")
                }
                else { //일반회원 신청서
                    self.readFormList(str:"/form/selectByMember/\(self.userPk)")
                }
            }
        }
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight=200
        tableView.rowHeight=140
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    @IBAction func clickMenuSeg(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            // 작성공고
        case 0:
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.underLine.frame.origin.x = 0
                }
            )
            setUp()
            break
            
            // 입양 / 임시보호 신청서
        case 1:
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.underLine.frame.origin.x = self.underLine.frame.maxX
                }
            )
            setUp()
            break
            
        default:
            break
        }
    }
    
}

extension MypageViewController{
    
    func beginPaging() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.isPaging = true
            self.setUp()
        }
    }
    
    func readMissingNotice(Id: Int){
        missingM.readMissingNotices(str: "/missing_notice/selectAllByMember/\(Id)", page: pageNum) {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.pageNum += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isPaging = false
            }
        }
    }
    
    func readAbandonedNotice(Id: Int){
        abandonedM.readAbandonedNotices(str: "/abandoned_notice/selectAllByStaff/\(Id)", page: pageNum) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.pageNum += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isPaging = false
            }
        }
    }
    
    func readFormList(str:String){
        formM.readFormList(str: str){
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
