//
//  Person.swift
//  Person Information MVC
//
//  Created by Sabin Tabirca on 13/02/2023.
//

import Foundation

class Player{
    // properties
    var name : String
    var age : String
    var img : String
    var img2: String
    var insta:String
    var twitter:String
    var style:String
    var internationaldebut:String
    var info : String
    var web : String
    var playingstyle: String
    
    // init
    init(name: String, age: String, img: String,img2:String,insta:String,twitter:String,internationaldebut:String,style:String, info: String, web: String, playingstyle: String) {
        self.name = name
        self.age = age
        self.img = img
        self.img2=img2
        self.insta=insta
        self.twitter=twitter
        self.internationaldebut=internationaldebut
        self.style=style
        self.info = info
        self.web = web
        self.playingstyle=playingstyle
    }
    
    // methods
}
