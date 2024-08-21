//
//  ContactCell.swift
//  Ios_Assignment2_Remake
//
//  Created by Shubham Karekar on 15/04/2023.
//


import UIKit


class ContactCell:UITableViewCell{
    
    var link: FavouriteTableTableViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .red
        
        let startbutton = UIButton(type: .system)
        //startbutton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        startbutton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        startbutton.layer.cornerRadius = startbutton.frame.width / 2
        startbutton.clipsToBounds = true
        startbutton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)

        accessoryView = startbutton
        accessoryView?.backgroundColor = .lightGray
        backgroundColor = .systemGray2
    }
    @objc private func handleMarkAsFavorite() {
        
        
        link?.someMethodIWantToCall(cell: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
