//
//  CustomCell.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 13.07.22.
//

import UIKit

class CustomCell: UICollectionViewCell {

    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    override var isSelected: Bool {
        didSet {
            blurView.isHidden = !isSelected
        }
    }
}
