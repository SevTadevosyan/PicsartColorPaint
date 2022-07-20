//
//  SettingsViewController.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 18.07.22.
//

import UIKit



class SettingsViewController: UIViewController {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var widthValue: UILabel!
    @IBOutlet weak var opacityValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        widthSlider.value = Float(PenConfiguration.shared.width)
        opacitySlider.value = Float(PenConfiguration.shared.opacity)
        widthValue.text = "\(Int(PenConfiguration.shared.width))"
        opacityValue.text = "\(Int(Float(round(100 * PenConfiguration.shared.opacity) / 100) * 100))%"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func setWidth(_ sender: UISlider) {
        PenConfiguration.shared.width = CGFloat(sender.value)
        widthValue.text = "\(Int(sender.value))"
    }
    
    @IBAction func setOpacity(_ sender: UISlider) {
        PenConfiguration.shared.opacity = CGFloat(sender.value)
        opacityValue.text = "\(Int(Float(round(100 * sender.value) / 100) * 100))% "
    }
}

