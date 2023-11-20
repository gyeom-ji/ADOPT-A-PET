//
//  CustomSideMenuViewController.swift
//  FirstProject
//
//  Created by 윤겸지 on 2022/11/10.
//

import Foundation
import UIKit
import SideMenu

class CustomSideMenuNavigation: SideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentationStyle = .menuSlideIn
        //보여지는 속도
        self.presentDuration = 1.0
        //사라지는 속도
        self.dismissDuration = 1.0
    }
}
