//
//  SIViewController.swift
//  SISwitchDemo
//
//  Created by Mohd Sazid Iqabal on 03/05/20.
//  Copyright © 2020 Sazid. All rights reserved.
//

import UIKit

class SIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let customSwitch = SISwitch(frame: CGRect(x: UIScreen.main.bounds.width/2-50, y: 200, width: 100, height: 50))
        customSwitch.bgOffColor = UIColor.green
        self.view.addSubview(customSwitch)
    }


}

