//
//  ColorViewController.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 19.07.22.
//

import Foundation
import UIKit


class ColorViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    let colorModel = ColorModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ColorCell", bundle: nil), forCellWithReuseIdentifier: "ColorCell")
        
    }
}

extension ColorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorModel.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        cell.colorView.backgroundColor = .brown
        let color = colorModel.colors[indexPath.item]
        cell.colorView.backgroundColor = color
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PenConfiguration.shared.penColor = colorModel.colors[indexPath.item].cgColor
        self.dismiss(animated: true)
    }
    
}

extension ColorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.width / 5)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
}

