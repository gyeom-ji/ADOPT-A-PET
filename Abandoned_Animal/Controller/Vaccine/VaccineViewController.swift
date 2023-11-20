//
//  VaccineViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/31.
//

import Foundation
import UIKit

extension VaccineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.vaccineM.vaccineList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.vaccineM.vaccineList.count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VaccineTableViewCell", for: indexPath) as? VaccineTableViewCell
        else {fatalError("no matched TableViewCell identifier")}
        
        let vaccine = self.vaccineM.vaccineList[indexPath.row]
        
        cell.firstContent.text = vaccine.name
        cell.secondContent.text = vaccine.animalType
        cell.thirdContent.text = vaccine.basicVaccine
        cell.fourthContent.text = vaccine.addVaccine
        cell.fifthContent.text = vaccine.boosterVaccine
        
        cell.imgView.image = UIImage(named: vaccine.animalType == "개" ? "dog-2" : vaccine.animalType == "고양이" ? "cat" : "rabbit")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            vaccineM.deleteVaccine(id: vaccineM.vaccineList[indexPath.row].id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}


class VaccineViewController: UIViewController{
    private var vaccineM = VaccineModel.shared
    
    @IBOutlet weak var insertBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.setUp()
        }
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if defaults.integer(forKey: "userType") == 0 {
            insertBtn.isHidden = false
            deleteBtn.isHidden = false
        }
        else{
            insertBtn.isHidden = true
            deleteBtn.isHidden = true
        }
        
        setupTableView()
        
        hideKeyboardWhenTappedAround()
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = 120
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setUp() {
        
        vaccineM.readVaccineList(){
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func clickInsertBtn(_ sender: UIButton) {
        let storyboardName = "Main"
        let storyboardID = "VaccineInsertViewController"
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let detailVC = storyboard.instantiateViewController(identifier: storyboardID)
        
        detailVC.hero.isEnabled = true
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        present(detailVC, animated: true, completion: nil)
    }
    
    @IBAction func clickDeleteBtn(_ sender: UIButton) {
        
        if tableView.isEditing {
            // Edit mode off
            tableView.setEditing(false, animated: true)
            deleteBtn.setImage(UIImage(systemName: "trash"), for: .normal)
        } else {
            // Edit mode on
            tableView.setEditing(true, animated: true)
            deleteBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
    }
}
