//
//  ViewController.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 13.07.22.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func showItemsViewController(_ sender: UIButton) {
        self.show(name: "ItemsViewController", transitionStyle: .crossDissolve, presentationStyle: .fullScreen)
    }
}

