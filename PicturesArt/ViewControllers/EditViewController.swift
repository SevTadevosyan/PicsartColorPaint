//
//  EditViewController.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 13.07.22.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var canvasView: UIImageView!
    @IBOutlet weak var pencilToolButton: UIButton!
    @IBOutlet weak var eraserToolButton: UIButton!
    @IBOutlet weak var lineToolButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var importedImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var shadowView: UIView!
    
    var lines = [Line]()
    var redoLines = [Line]()
    var buttons = [UIButton]()
    var timer: Timer?
    var index: Int?
    var img = UIImage()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if let imageData = canvasView.image?.pngData() {
            ItemsViewModel.shared.imageDatas[ItemsViewModel.shared.currentImageIndex].image = imageData
            do {
                try CoreDataHelper.shared.context.save()
            } catch {
                
            }
        }
        PenConfiguration.shared.type = .pen
        if canvasView.image != nil {
            ItemsViewModel.shared.images[ItemsViewModel.shared.images.count - 1] = canvasView.image!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func stopIndicatorAnimation() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        shadowView.isHidden = true
    }
    
    func configure() {
        canvasView.gestureRecognizers![0].delegate = self
        canvasView.backgroundColor = .white
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
        let vc = UIImagePickerController()
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
                vc.imageView.image = self.canvasView.image!
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
        canvasView.transform = canvasView.transform.scaledBy(x: sender.scale,
                                                             y: sender.scale)
        sender.scale = 1
    }
    
    @IBAction func rotateEditingView(_ sender: UIRotationGestureRecognizer) {
        canvasView.transform = canvasView.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    @IBAction func changePosition(_ sender: UIPanGestureRecognizer) {
        
    }
}

extension EditViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            importedImage.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
