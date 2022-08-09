//
//  ViewController2.swift
//  Test
//
//  Created by PC on 07/07/22.
//

import UIKit

class ViewController2: UIViewController {

    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.allowLandscape = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.allowLandscape = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
