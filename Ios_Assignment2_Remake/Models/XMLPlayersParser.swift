////
////  XMLPeopleParser.swift
////  Person Information MVC
////
////  Created by Shubham Karekar on 03/03/2023.
////
//
import Foundation

class XMLPlayersParser: NSObject, XMLParserDelegate{
    // property + init
    var name:String
    init(name:String) {
        self.name = name
        
    }
    
    //p vars to store the parsed info
    var pName, pAge, pImage,pImage2,pInsta,pTwitter,pinternationaldebut,pStyle, pInfo,pWeb,pPlayingstyle : String!
    let tags = ["name", "age", "img","img2","insta","twitter","internationaldebut","style", "info", "web","playingstyle"]
    
    // vars for spying
    var elementId = -1
    var passData = false
    
    // objs for created data
    var personData : Player!
    var peopleData = [Player]()
    
    // parser obj
    var parser : XMLParser!
    
    //MARK:- parsing methods
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // read a start tag for elementName
        if tags.contains(elementName){
            passData = true
            
            //check what tag to spy
            switch elementName{
                case "name"     : elementId = 0
                case "age"  : elementId = 1
                case "img"    : elementId = 2
                case "img2":elementId=3
                case "insta":elementId=4
                case "twitter":elementId=5
                case "internationaldebut":elementId=6
                case "style":elementId=7
                case "info"    : elementId = 8
                case "web"    : elementId = 9
                case "playingstyle": elementId=10
                default: break;
            }
        }
        
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // Found an end tag ==> reset the spies
        if tags.contains(elementName){
            passData = false
            elementId = -1
        }
        
        // check if end tag person to make a Persons onj
        
        if elementName == "player" {
            personData = Player(name:pName, age: pAge, img: pImage,img2:pImage2,insta: pInsta,twitter: pTwitter,internationaldebut:pinternationaldebut ,style:pStyle, info: pInfo, web: pWeb,playingstyle: pPlayingstyle)
            peopleData.append(personData)
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // if the tag is spies then store the data
        if passData{
            //populate the pVars
            switch elementId{
                case 0:pName    = string
                case 1:pAge = string
                case 2:pImage   = string
                case 3:pImage2 = string
                case 4:pInsta=string
                case 5:pTwitter=string
                case 6:pinternationaldebut=string
                case 7:pStyle=string
                case 8:pInfo   = string
                case 9:pWeb   = string
                case 10:pPlayingstyle=string
                default: break;
            }
        }
    }
        
        // begin parsing
        func parsing(){
            // get the file from bundle
            let bundle = Bundle.main.bundleURL
            let bundleURL = NSURL(fileURLWithPath: self.name, relativeTo: bundle)
            
            // make the parser, delege it
            parser = XMLParser(contentsOf: bundleURL as URL)
            parser.delegate = self
            parser.parse()
        }
    
}

