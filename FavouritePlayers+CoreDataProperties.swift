//
//  FavouritePlayers+CoreDataProperties.swift
//  Ios_Assignment2_Remake
//
//  Created by Shubham Karekar on 17/04/2023.
//
//

import Foundation
import CoreData


extension FavouritePlayers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouritePlayers> {
        return NSFetchRequest<FavouritePlayers>(entityName: "FavouritePlayers")
    }

    @NSManaged public var teamname: String?
    @NSManaged public var playername: String?
    @NSManaged public var age: String?

}

extension FavouritePlayers : Identifiable {

}
