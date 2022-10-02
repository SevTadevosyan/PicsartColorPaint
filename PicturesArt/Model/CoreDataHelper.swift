//
//  CoreDataHelper.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 07.08.22.
//

import UIKit
import CoreData


class CoreDataHelper {
    static let shared = CoreDataHelper()
    private init() {}
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImage(data: Data) {
        let imageInstance = Image(context: context)
        imageInstance.image = data
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage() {
        var fetchingImages = [Image]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
        do {
            fetchingImages = try context.fetch(fetchRequest) as! [Image]
        } catch {
            print("Error while fetching the image")
        }
        ItemsViewModel.shared.imageDatas = fetchingImages
    }
}
