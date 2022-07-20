//
//  LaunchViewController.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 13.07.22.
//
import UIKit

class ItemsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.register(UINib(nibName: "DefaultCell", bundle: nil), forCellWithReuseIdentifier: "DefaultCell")
        collectionView.register(UINib(nibName: "CustomCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func openEditViewController(at index: Int) {
        guard let drawingViewController = storyboard?.instantiateViewController(identifier: "EditViewController") as? EditViewController else { return }
        drawingViewController.modalTransitionStyle = .coverVertical
        drawingViewController.modalPresentationStyle = .fullScreen
        drawingViewController.index = index
        
        self.present(drawingViewController, animated: true) {
//            drawingViewController.canvasView = ItemsViewModel.shared.views[index - 1]
        }
    }
    
    @IBAction func showPopUp(_ sender: UIButton) {
        
    }
}

extension ItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ItemsViewModel.shared.cellsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        if indexPath.item == 0 {
            return defaultCell
        } else {
            let image = ItemsViewModel.shared.images[indexPath.item - 1]
            customCell.imageView.image = image
        }
        return customCell
    }
}

extension ItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 30, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            ItemsViewModel.shared.cellsCount += 1
            ItemsViewModel.shared.images.append(UIImage())
            ItemsViewModel.shared.views.append(Canvas())
            collectionView.reloadData()
            openEditViewController(at: indexPath.item + ItemsViewModel.shared.images.count)
        } else {
            openEditViewController(at: indexPath.item)
        }
    }
    
}
