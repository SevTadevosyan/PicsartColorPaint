//
//  Extensions.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 16.07.22.
//

import UIKit

extension UIImageView {
    func asImage() -> CGImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        } as! CGImage
    }
}

extension UIViewController {
    func show(name: String, transitionStyle: UIModalTransitionStyle, presentationStyle: UIModalPresentationStyle) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: name)
        vc.modalTransitionStyle = transitionStyle
        vc.modalPresentationStyle = presentationStyle
        self.present(vc, animated: true)
    }
    func openEditViewController(at index: Int) {
        guard let drawingViewController = storyboard?.instantiateViewController(identifier: "EditViewController") as? EditViewController else { return }
        drawingViewController.modalTransitionStyle = .coverVertical
        drawingViewController.modalPresentationStyle = .fullScreen
        drawingViewController.index = index
        
        self.present(drawingViewController, animated: true) {
            drawingViewController.index = index
            PenConfiguration.shared.color = PenConfiguration.shared.penColor
            drawingViewController.canvasImageView.image = ItemsViewModel.shared.images[index - 1]
        }
    }
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
      }
}
