//
//  LaunchViewController.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 13.07.22.
//
import UIKit

enum Mode {
    case select
    case normal
}

class ItemsViewController: UIViewController {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var deleteButton: UIButton!

    
    var selectedImages: [IndexPath : Image] = [:]
    var selectedItemsIndexPaths: [IndexPath : Bool] = [:]
    
    var mode: Mode = .normal {
        didSet {
            switch mode {
            case .select:
                selectedItemsIndexPaths.removeAll()
                collectionView.visibleCells[0].isSelected = true
                deleteButton.isHidden = false
                collectionView.cellForItem(at: [0,0])?.isOpaque = true
                selectButton.setTitle("Cancel", for: .normal)
                collectionView.allowsMultipleSelection = true
            case .normal:
                collectionView.visibleCells[0].isSelected = false
                selectButton.setTitle("Select", for: .normal)
                for (key,value) in selectedItemsIndexPaths {
                    if value {
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
                collectionView.allowsMultipleSelection = false
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.register(UINib(nibName: "DefaultCell", bundle: nil), forCellWithReuseIdentifier: "DefaultCell")
        collectionView.register(UINib(nibName: "CustomCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchImages()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        selectButton.isEnabled = ItemsViewModel.shared.images.count == 0 ? false : true
    }
    
    
    func fetchImages() {
        CoreDataHelper.shared.fetchImage()
        ItemsViewModel.shared.convertToUIImage()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func selectItems(_ sender: UIButton) {
        deleteButton.isEnabled = false
        mode = mode == .select ? .normal : .select
        switch mode {
        case .select:
            deleteButton.isHidden = false
        case .normal:
            deleteButton.isHidden = true
        }
        collectionView.reloadData()
    }
    
    @IBAction func deleteImages(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete", message: "Items will delete forever.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            for (_ , item) in self.selectedImages {
                CoreDataHelper.shared.context.delete(item)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            do {
                try CoreDataHelper.shared.context.save()
                
            }
            catch {
                print(error.localizedDescription)
            }
            self.fetchImages()
            self.deleteButton.isHidden = true
            self.mode = .normal
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true)
    }
}

extension ItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(ItemsViewModel.shared.images.count)
        return ItemsViewModel.shared.images.count + 1
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
        return CGSize(width: collectionView.frame.width / 2 - 30, height: collectionView.frame.height / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mode {
        case .normal:
            if indexPath.item == 0 {
                ItemsViewModel.shared.imageDatas.append(Image(context: CoreDataHelper.shared.context))
                ItemsViewModel.shared.images.append(UIImage(named: "whiteImage")!)
                ItemsViewModel.shared.currentImageIndex = ItemsViewModel.shared.imageDatas.count - 1
                openEditViewController(at: ItemsViewModel.shared.images.count)
                collectionView.deselectItem(at: indexPath, animated: true)
                collectionView.reloadData()
            } else {
                collectionView.deselectItem(at: indexPath, animated: true)
                ItemsViewModel.shared.currentImageIndex = indexPath.item - 1
                openEditViewController(at: indexPath.item)
            }
            
        case .select:
            if indexPath.item != 0 {
                selectedItemsIndexPaths[indexPath] = true
                selectedImages[indexPath] = ItemsViewModel.shared.imageDatas[indexPath.item - 1]
                if selectedImages.count > 0 {
                    deleteButton.isEnabled = true
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mode == .select && indexPath.item != 0 {
            selectedImages.removeValue(forKey: indexPath)
            selectedItemsIndexPaths[indexPath] = false
            if selectedImages.count == 0 {
                deleteButton.isEnabled = false
            }
        }
        
    }
}
