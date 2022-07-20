//
//  Extensions.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 16.07.22.
//

import UIKit

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIViewController {
    func show(_ name: String, transitionStyle: UIModalTransitionStyle, presentationStyle: UIModalPresentationStyle) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: name)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = presentationStyle
        self.present(vc, animated: true)
    }
}
