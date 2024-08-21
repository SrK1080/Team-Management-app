//
//  PlayerEntity+CoreDataProperties.swift
//  Ios_Assignment2_Remake
//
//  Created by Shubham Karekar on 17/04/2023.
//
//

import Foundation
import CoreData


extension PlayerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerEntity> {
        return NSFetchRequest<PlayerEntity>(entityName: "PlayerEntity")
    }

    @NSManaged public var age: String?
    @NSManaged public var img: String?
    @NSManaged public var img2: String?
    @NSManaged public var info: String?
    @NSManaged public var insta: String?
    @NSManaged public var internationaldebut: String?
    @NSManaged public var name: String?
    @NSManaged public var playingstyle: String?
    @NSManaged public var style: String?
    @NSManaged public var twitter: String?
    @NSManaged public var web: String?
    @NSManaged public var hasfavourited: Bool

}

extension PlayerEntity : Identifiable {

}
