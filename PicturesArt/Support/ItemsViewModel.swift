//
//  ItemsViewModel.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 17.07.22.
//

import UIKit

class ItemsViewModel {
    static let shared = ItemsViewModel()
    private init() {}
    var images: [UIImage] = []
    var imageDatas: [Image] = []
    var currentImageIndex = 0
    
    func convertToUIImage() {
        images = []
        for i in 0..<imageDatas.count {
            images.append(UIImage())
            if imageDatas[i].image != nil {
                images[i] = UIImage(data: imageDatas[i].image!)!
            }
        }
    }
}

class PenConfiguration {
    
    static let shared = PenConfiguration()
    private init() {}
    
    var width: CGFloat = 10
    var opacity: CGFloat = 1.0
    var color: CGColor = UIColor.black.cgColor
    var penColor: CGColor = UIColor.black.cgColor
    var type: DrawingTypes = .pen
}

struct Line {
    var color = PenConfiguration.shared.color
    var points = [CGPoint]()
    var width = PenConfiguration.shared.width
    var opacity = PenConfiguration.shared.opacity
    var type = PenConfiguration.shared.type
}

enum DrawingTypes {
    case pen
    case line
}
