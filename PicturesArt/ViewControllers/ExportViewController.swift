//
//  ExportViewController.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 16.07.22.
//

import UIKit

class ExportViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
    
    func saveJpg(_ image: UIImage) {
        
        if let jpgData = image.jpegData(compressionQuality: 1.0),
            let path = documentDirectoryPath()?.appendingPathComponent("exampleJpg.jpg") {
            try? jpgData.write(to: path)
        }
    }
    @IBAction func exportImageIntoGallery(_ sender: UIButton) {
        let imageData = self.imageView.image!.pngData()
        guard let compresedImage = UIImage(data: imageData!) else { return }
        UIImageWriteToSavedPhotosAlbum(compresedImage, self, #selector(image(path:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc private func image(path: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        if ((error) != nil) {
            print("something went wrong!")
        } else {
            print("Done!")
        }
    }
    
    @IBAction func openPicsart(_ sender: UIButton) {
        if let url = URL(string: "https://apps.apple.com/us/app/picsart-photo-video-editor/id587366035") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func selfDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
