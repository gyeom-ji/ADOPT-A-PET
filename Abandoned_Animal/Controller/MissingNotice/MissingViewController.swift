//
//  MissingViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation
import UIKit

extension MissingViewController: SendKindInfoDelegate{
    func sendKindInfo(isDog: Bool, isCat: Bool, isEct: Bool) {
        self.isDog = isDog
        self.isCat = isCat
        self.isEct = isEct
        
        urlString = "/missing_notice/selectByKind/\(isDog)/\(isCat)/\(isEct)"
        pageNum = 0
        setUp()
    }
}

extension MissingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.missingM.missingNoticeList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.missingM.missingNoticeList.count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MissingNoticeTableViewCell", for: indexPath) as? MissingNoticeTableViewCell
        else {fatalError("no matched TableViewCell identifier")}
        
        let notice = self.missingM.missingNoticeList[indexPath.row]
        cell.animalSex?.text = notice.animal.sex
        cell.animalBreed?.text = notice.animal.breed
        cell.name?.text = notice.animalName
        cell.missingPlace?.text = notice.place
        cell.missingDate?.text = notice.date
        
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
        
        if let selectedIndex =
            tableView.indexPathForSelectedRow?.row {
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "MissingDetailViewController")as? MissingDetailViewController else {return}
            missingM.missingNotice.id = missingM.missingNoticeList[selectedIndex].id
            nextVC.hero.isEnabled = true
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
            self.present(nextVC, animated: true, completion: nil)
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

class MissingViewController: UIViewController{
    private var missingM = MissingNoticeModel.shared
    
    @IBOutlet weak var tableView: UITableView!
    var isDog: Bool?
    var isCat: Bool?
    var isEct: Bool?
    var pageNum: Int = 0
    var isPaging: Bool = false
    var urlString = String()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "missingSearch" {
            guard let viewController: MissingSearchViewController = segue.destination as? MissingSearchViewController else {return}
            viewController.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight=200
        tableView.rowHeight=140
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.urlString = "/missing_notice/selectAll"
            self.pageNum = 0
            self.setUp()
        }
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    func beginPaging() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.isPaging = true
            self.setUp()
        }
    }
    
    private func setUp() {
        
        missingM.readMissingNotices(str: urlString, page: pageNum) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.pageNum += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isPaging = false
            }
        }
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func clickInsertMissingBtn(_ sender: UIButton) {
        let storyboardName = "Main"
        let storyboardID = "MissingNoticeInsertViewController"
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let detailVC = storyboard.instantiateViewController(identifier: storyboardID)
        
        detailVC.hero.isEnabled = true
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        present(detailVC, animated: true, completion: nil)
    }
}
