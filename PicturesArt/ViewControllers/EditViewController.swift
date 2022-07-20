//
//  EditViewController.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 13.07.22.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var canvasView: Canvas!
    @IBOutlet weak var pencilToolButton: UIButton!
    @IBOutlet weak var eraserToolButton: UIButton!
    @IBOutlet weak var lineToolButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    var index: Int?
    var buttons = [UIButton]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func configure() {
        canvasView.delegate = self
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
    }
    
    func configureUndoRedoButtonStates() {
        
        if canvasView.lines.count == 0 {
            undoButton.isEnabled = false
        } else {
            undoButton.isEnabled = true
        }
        if canvasView.redoLines.count == 0 {
            redoButton.isEnabled = false
        } else {
            redoButton.isEnabled = true
        }
    }
    
    @IBAction func exit(_ sender: UIButton) {
        if ItemsViewModel.shared.images.count == ItemsViewModel.shared.cellsCount - 1 {
            ItemsViewModel.shared.images[index! - 1] = canvasView.asImage()
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func undoChange(_ sender: UIButton) {
        canvasView.undo()
        configureUndoRedoButtonStates()
    }
    
    @IBAction func redoChange(_ sender: UIButton) {
        canvasView.redo()
        configureUndoRedoButtonStates()
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        
    }
    
    @IBAction func saveImageIntoGallery(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ExportViewController") as? ExportViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true) {
            DispatchQueue.main.async {
                vc.imageView.image = self.canvasView.asImage()
            }
        }
    }
    
    @IBAction func chooseColor(_ sender: UIButton) {
        self.show("ColorViewController", transitionStyle: .coverVertical, presentationStyle: .formSheet)
    }
    
    @IBAction func usePencil(_ sender: UIButton) {
        PenConfiguration.shared.type = .pen
        deselectExceptFor(button: pencilToolButton)
        PenConfiguration.shared.color = PenConfiguration.shared.penColor
    }
    
    @IBAction func drawGradient(_ sender: UIButton) {
        deselectExceptFor(button: lineToolButton)
        PenConfiguration.shared.type = .line
    }
    
    @IBAction func useEraser(_ sender: UIButton) {
        deselectExceptFor(button: eraserToolButton)
        PenConfiguration.shared.type = .pen
        PenConfiguration.shared.color = UIColor.white.cgColor
    }
    
    @IBAction func showSettings(_ sender: UILongPressGestureRecognizer) {
        self.show("SettingsViewController", transitionStyle: .coverVertical, presentationStyle: .formSheet)
    }
    
    @IBAction func zoomEditingView(_ sender: UIPinchGestureRecognizer) {
        canvasView.transform = canvasView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
    
    @IBAction func rotateEditingView(_ sender: UIRotationGestureRecognizer) {
        canvasView.transform = canvasView.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    @IBAction func changePosition(_ sender: UIPanGestureRecognizer) {
        
    }
}

extension EditViewController: CanvasDelegate {
    func didTapped() {
        if eraserToolButton.isSelected == true {
            PenConfiguration.shared.color = UIColor.white.cgColor
        }
        undoButton.isEnabled = true
    }
}

extension EditViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
