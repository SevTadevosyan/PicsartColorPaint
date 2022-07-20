//
//  ItemsViewModel.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 17.07.22.
//

import UIKit

class ItemsViewModel {
    
    static let shared = ItemsViewModel()
    var currentImage = UIImage()
    private init() {}
    var images: [UIImage] = []
    var views: [Canvas] = []
    var cellsCount = 1
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
}

enum DrawingTypes {
    case pen
    case line
}
