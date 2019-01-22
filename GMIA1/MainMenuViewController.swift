//
//  MainMenuViewController.swift
//  GMIA1
//
//  Created by Sam Ritchie on 22/1/19.
//  Copyright © 2019 Rene Van Meeuwen. All rights reserved.
//

import UIKit

final class MainMenuViewController: UIViewController {
//    override var shouldAutorotate: Bool {
//        return false
//    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft,  .landscapeRight]
    }
    
    @IBAction func backToMainMenu(_ segue: UIStoryboardSegue) { }
}
