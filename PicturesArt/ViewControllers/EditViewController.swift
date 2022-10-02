//
//  EditViewController.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 13.07.22.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var canvasImageView: UIImageView!
    @IBOutlet weak var pencilToolButton: UIButton!
    @IBOutlet weak var eraserToolButton: UIButton!
    @IBOutlet weak var lineToolButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var importedImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var importedImageCheckBarView: UIView!
    @IBOutlet weak var importedImageBackgroundView: UIView!
    
    var lines = [Line]()
    var redoLines = [Line]()
    var buttons = [UIButton]()
    var timer: Timer?
    var index: Int?
    var img = UIImage()
    var importedImg = UIImage()
    var isImported = false
    let vc = UIImagePickerController()

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        draw()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.isHidden = false
        shadowView.isHidden = false
        activityIndicator.startAnimating()
        timer?.invalidate()
        Timer.scheduledTimer(timeInterval: 0.5,
                             target: self,
                             selector: #selector(stopIndicatorAnimation),
                             userInfo: nil,
                             repeats: false)
        PenConfiguration.shared.penColor = UIColor.black.cgColor
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ItemsViewModel.shared.imageDatas[ItemsViewModel.shared.currentImageIndex].image = canvasImageView.image?.pngData() ?? UIImage().pngData()
        do {
            try CoreDataHelper.shared.context.save()
        } catch {
            print(error.localizedDescription)
        }
        PenConfiguration.shared.type = .pen
        ItemsViewModel.shared.images[ItemsViewModel.shared.images.count - 1] = canvasImageView.image!
    }
    
    @objc func stopIndicatorAnimation() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        shadowView.isHidden = true
    }
    
    func configure() {
        canvasImageView.gestureRecognizers![0].delegate = self
        canvasImageView.backgroundColor = .white
        pencilToolButton.isSelected = true
        buttons.append(pencilToolButton)
        buttons.append(eraserToolButton)
        buttons.append(lineToolButton)
    }
    
    func deselectExceptFor(button: UIButton) {
        for b in buttons {
            if b != button {
                b.isSelected = false
            }
        }
        button.isSelected = true
    }
    
    func configureUndoRedoButtonStates() {
        
        if lines.count == 0 {
            undoButton.isEnabled = false
        } else {
            undoButton.isEnabled = true
        }
        if redoLines.count == 0 {
            redoButton.isEnabled = false
        } else {
            redoButton.isEnabled = true
        }
    }
    
    @IBAction func exit(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func undoChange(_ sender: UIButton) {
        undo()
        configureUndoRedoButtonStates()
    }
    
    @IBAction func redoChange(_ sender: UIButton) {
        redo()
        configureUndoRedoButtonStates()

    }
    
    @IBAction func addImage(_ sender: UIButton) {
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func saveImageIntoGallery(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ExportViewController") as? ExportViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true) {
            DispatchQueue.main.async {
                vc.imageView.image = self.canvasImageView.image!
            }
        }
        
    }
    
    @IBAction func chooseColor(_ sender: UIButton) {
        self.show(name: "ColorViewController",
                  transitionStyle: .coverVertical,
                  presentationStyle: .formSheet)
    }
    
    @IBAction func usePencil(_ sender: UIButton) {
        PenConfiguration.shared.type = .pen
        deselectExceptFor(button: pencilToolButton)
        PenConfiguration.shared.color = PenConfiguration.shared.penColor
    }
    
    @IBAction func useDirectLine(_ sender: UIButton) {
        PenConfiguration.shared.type = .line
        deselectExceptFor(button: lineToolButton)
        PenConfiguration.shared.color = PenConfiguration.shared.penColor
    }
    
    @IBAction func useEraser(_ sender: UIButton) {
        deselectExceptFor(button: eraserToolButton)
        PenConfiguration.shared.type = .pen
        PenConfiguration.shared.color = UIColor.white.cgColor
    }
    
    @IBAction func showSettings(_ sender: UILongPressGestureRecognizer) {
        self.show(name: "SettingsViewController",
                  transitionStyle: .coverVertical,
                  presentationStyle: .formSheet)
    }
    
    @IBAction func zoomEditingView(_ sender: UIPinchGestureRecognizer) {
        canvasImageView.transform = canvasImageView.transform.scaledBy(x: sender.scale,
                                                             y: sender.scale)
        sender.scale = 1
    }
    
    @IBAction func rotateEditingView(_ sender: UIRotationGestureRecognizer) {
        canvasImageView.transform = canvasImageView.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    @IBAction func changePosition(_ sender: UIPanGestureRecognizer) {
        
    }
    
    @IBAction func changeImportedImagePosition(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        importedImageBackgroundView.center = CGPoint(x: importedImageBackgroundView.center.x + translation.x,
                                                     y: importedImageBackgroundView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    @IBAction func increaseUp(_ sender: UIButton) {
        importedImageBackgroundView.transform = importedImageBackgroundView.transform.scaledBy(x: 2, y: 2)
        canvasImageView.setNeedsDisplay()
    }
    
    @IBAction func setNewImage(_ sender: UIButton) {
        let size = canvasImageView.frame.size
        UIGraphicsBeginImageContext(size)
        importedImg.draw(at: importedImage.frame.origin, blendMode: .normal, alpha: 1.0)
        canvasImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        importedImageBackgroundView.isHidden = true
        importedImageCheckBarView.isHidden = true
    }
    
    @IBAction func resetNewImage(_ sender: UIButton) {
        importedImage.image = UIImage()
        importedImageBackgroundView.isHidden = true
        importedImageCheckBarView.isHidden = true
    }
}

extension EditViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage else { return }
        importedImage.image = image
        importedImg = importedImage.image!
        importedImage.isHidden = false
        importedImageCheckBarView.isHidden = false
        isImported = true
        importedImageBackgroundView.isHidden = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


