//
//  ShelterListViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation
import UIKit

extension ShelterListViewController: SendRegionInfoDelegate{
    func sendRegionInfo(region: String, city: String) {
        self.region = region

        regionBtn.setTitle("지역 : " + region + ", " + city != "전체" ? city : "" , for: .normal)
        
        urlString = "/shelter/selectByRegion/\(region)/\(city)"
        pageNum = 0
        setUp()
    }
}

extension ShelterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter {
            return self.shelterM.filterShelterList.count
        }
        else {
            return self.shelterM.shelterList.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFilter {
            return self.shelterM.filterShelterList.count == 0 ? 0 : 1
        }
        else {
            return self.shelterM.shelterList.count == 0 ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShelterTableViewCell", for: indexPath) as? ShelterTableViewCell
        else {fatalError("no matched TableViewCell identifier")}
        
        let notice : Shelter
        if isFilter {
            notice = self.shelterM.filterShelterList[indexPath.row]
        }
        else{
            notice = self.shelterM.shelterList[indexPath.row]
        }
        cell.name?.text = notice.name
        cell.phone?.text = notice.phone
        let str = notice.city + " " + notice.county + " " + notice.address
        cell.address?.text = str
      
        let num = Int.random(in: 0...2)

        cell.imgView.image = UIImage(named: num == 0 ? "dog-2" : num == 1 ? "cat" : "rabbit")
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let selectedIndex =
            tableView.indexPathForSelectedRow?.row {
            
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "ShelterDetailViewController")as? ShelterDetailViewController else {return}
            if isFilter {
                shelterM.shelter = shelterM.filterShelterList[selectedIndex]
            }
            else {
                shelterM.shelter = shelterM.shelterList[selectedIndex]
            }
        
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
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}


class ShelterListViewController: UIViewController{
    private var shelterM = ShelterModel.shared
    
    @IBOutlet weak var insertBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var textField: UITextFieldDesignable!
    @IBOutlet weak var tableView: UITableView!
    
    var region = String()
    var isFilter = Bool()
    var pageNum: Int = 0
    var isPaging: Bool = false
    var urlString = String()
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.urlString = "/shelter/selectAll"
            self.pageNum = 0
            self.setUp()
        }
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.isFilter = false
        self.textField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let defaults = UserDefaults.standard
        
        if defaults.integer(forKey: "userType") == 0 {
            insertBtn.isHidden = false
        }
        else{
            insertBtn.isHidden = true
        }
        
        setupTableView()

        hideKeyboardWhenTappedAround()
      
        textField.rightView = clearBtn
        textField.rightViewMode = UITextField.ViewMode.whileEditing
    }
    
    @IBAction func clickSearchBtn(_ sender: UIButton) {
        let text = textField.text

        if text != "" {
            isFilter = true
            
            shelterM.getFilterShelterList(text: text!)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        else {
            isFilter = false
            setUp()
        }
    }
    
    @IBAction func clickInsertBtn(_ sender: UIButton) {
        let storyboardName = "Main"
        let storyboardID = "ShelterInsertViewController"
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let detailVC = storyboard.instantiateViewController(identifier: storyboardID)
        
        detailVC.hero.isEnabled = true
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        present(detailVC, animated: true, completion: nil)
    }
    
    @IBAction func clickClearBtn(_ sender: UIButton) {
        textField.text = ""
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight=200
        tableView.rowHeight=120
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "regionSearch" {
            guard let viewController: RegionAlertViewController = segue.destination as? RegionAlertViewController else {return}
            viewController.delegate = self
        }
    }
    
    func beginPaging() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.isPaging = true
            self.setUp()
        }
    }
    
    private func setUp() {
        
        shelterM.readShelterList(str: urlString, page: pageNum) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.pageNum += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isPaging = false
            }
        }
    }
}
