//
//  People.swift
//  Person Information MVC
//
//  Created by Sabin Tabirca on 13/02/2023.
//

import Foundation

class Players{
    
    var data:[Player]!
    
//    init(){
//        self.data = [
//            Person(name: "Sabin Tabirca", email: "sabin@sabin.com", phone: "111111111", address: "WGB, UCC, Cork", image: "sabin.jpeg"),
//            Person(name: "Sabina Tabirca", email: "sabina@sabin.com", phone: "22222222", address: "CUMH, Cork", image: "sabina.jpeg"),
//            Person(name: "John Tabirca", email: "johm@sabin.com", phone: "33333333", address: "Loyds Pharm, Cork", image: "john.jpeg")
//        ]
//    }
    
    init(fromXMLFile:String){
        let parser=XMLPlayersParser(name: fromXMLFile)
        parser.parsing()
        self.data=parser.peopleData
        
    }
    
    
    // methods
    func getPerson(index:Int) -> Player{
        return data[index]
    }
    
    func getCount() -> Int{
        return data.count
    }
    
    func getNames() -> [String]{
        // make an empty array
        var names = [String]()
        
        // traverse the people data and place their names in array
        for personData in data{
            names.append(personData.name)
        }
        
        return names
    }
}

