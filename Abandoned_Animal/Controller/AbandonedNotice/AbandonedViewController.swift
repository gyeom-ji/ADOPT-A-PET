//
//  AbandonedViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation
import UIKit
import Hero
import SwiftyJSON

extension AbandonedViewController: SendSerchInfoDelegate{
    func sendSearchInfo(region: String, city:String, isDog: Bool, isCat: Bool, isEct: Bool) {
        
        self.region = region
        self.isDog = isDog
        self.isCat = isCat
        self.isEct = isEct
        print("\(region)/\(city)/\(isDog)/\(isCat)/\(isEct)")
        
        let str = region+"/"+city+"/"+String(isDog)+"/"+String(isCat)+"/"+String(isEct)
        urlString = "/abandoned_notice/selectByRegionAndKind/"+str
        pageNum = 0
        setUp()
    }
}

extension AbandonedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.abandonedM.abandonedNoticeList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.abandonedM.abandonedNoticeList.count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AbandonedNoticeTableViewCell", for: indexPath) as? AbandonedNoticeTableViewCell
        else {fatalError("no matched TableViewCell identifier")}
        
        let notice = self.abandonedM.abandonedNoticeList[indexPath.row]
        
        cell.animalSex?.text = notice.animal.sex
        cell.animalBreed?.text = notice.animal.breed
        cell.noticeNum?.text = notice.noticeNum
        cell.period?.text = notice.period
        
        if notice.animal.isUrl == true {
            let url = URL(string: notice.animal.img)
            cell.imgView.load(url: url!)
        }
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.height/2
        cell.imgView.layer.borderWidth = 3
        cell.imgView.layer.borderColor = UIColor.beige?.cgColor
        cell.imgView.clipsToBounds = true
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView.indexPathForSelectedRow?.row) != nil {
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "AbandonedDetailViewController")as? AbandonedDetailViewController else {return}
            
            abandonedM.abandonedNotice.id = abandonedM.abandonedNoticeList[indexPath.row].id
            
            nextVC.hero.isEnabled = true
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if  offsetY > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            
            if !isPaging {
                beginPaging()
            }
            
        }
        if self.tableView.contentOffset.y > 0 {
            randomMissingBtn.isHidden = true
        }
        else {
            randomMissingBtn.isHidden = false
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

class AbandonedViewController: UIViewController{
    private var abandonedM = AbandonedNoticeModel.shared
    private var missingM = MissingNoticeModel.shared
    
    @IBOutlet weak var insertBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var randomMissingBtn: UIButton!
    
    var isDog: Bool?
    var isCat: Bool?
    var isEct: Bool?
    var region: String?
    var pageNum: Int = 0
    var isPaging: Bool = false
    var urlString = String()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "abandonedSearch" {
            guard let viewController: AbandonedSearchViewController = segue.destination as? AbandonedSearchViewController else {return}
            viewController.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        randomMissingBtn.isHidden = false
        pageNum = 0
        DispatchQueue.main.async {
            self.animateView()
        }
    }
    
    func animateView(){
        
        UIView.animate(withDuration: 1.2, delay: 0,options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            let scale = CGAffineTransform(translationX: -15, y:0)
            self.randomMissingBtn.transform = scale
        }){
            (_) in
            self.randomMissingBtn.transform = .identity
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.urlString = "/abandoned_notice/selectAll"
            self.pageNum = 0
            self.setUp()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomMissingBtn.isHidden = false
        
        let defaults = UserDefaults.standard
        
        if defaults.integer(forKey: "userType") == 1 {
            insertBtn.isHidden = false
        }
        else{
            insertBtn.isHidden = true
        }
        
        self.isHeroEnabled = true
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = 140
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        setupTableView()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func beginPaging() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.isPaging = true
            self.setUp()
        }
    }
    
    private func setUp() {
        
        AbandonedNoticeModel.shared.readAbandonedNotices(str: urlString, page: pageNum) {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.pageNum += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isPaging = false
            }
        }
    }
    
    @IBAction func clickSearchBtn(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "AbandonedSearchViewController")as? AbandonedSearchViewController else {return}
        
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func clickInsertNoticeBtn(_ sender: UIButton) {
        let storyboardName = "Main"
        let storyboardID = "AbandonedNoticeInsertViewController"
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let detailVC = storyboard.instantiateViewController(identifier: storyboardID)
        
        detailVC.hero.isEnabled = true
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        present(detailVC, animated: true, completion: nil)
    }
    
    @IBAction func clickRandomMissingBtn(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "MissingDetailViewController")as? MissingDetailViewController else {return}
        
        missingM.readMissingRandom()
        nextVC.hero.isEnabled = true
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        self.present(nextVC, animated: true, completion: nil)
    }
}

