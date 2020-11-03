//
//  ViewController.swift
//  ev_map
//
//  Created by cse on 2020/11/03.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func directionTapped(_ sender: Any) {
        guard let controller = self.storyboard?.instantiateViewController(identifier: "DirectionSearchViewController") else { return }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

