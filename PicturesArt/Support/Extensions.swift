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
            drawingViewController.canvasView.image = ItemsViewModel.shared.images[index - 1]
//            drawingViewController.img = ItemsViewModel.shared.images[index - 1]
        }
    }
}
