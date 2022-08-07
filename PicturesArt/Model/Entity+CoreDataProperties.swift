//
//  Entity+CoreDataProperties.swift
//  PicturesArt
//
//  Created by Sevak Tadevosyan on 04.08.22.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var image: Data?

}

extension Image : Identifiable {

}
