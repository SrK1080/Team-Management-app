//
//  Team+CoreDataProperties.swift
//  Ios_Assignment2_Remake
//
//  Created by Shubham Karekar on 17/04/2023.
//
//

import Foundation
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @NSManaged public var teamname: String?
    @NSManaged public var year: String?
    @NSManaged public var image: String?

}

extension Team : Identifiable {

}
