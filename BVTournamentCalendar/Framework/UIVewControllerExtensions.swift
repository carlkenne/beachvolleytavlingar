//
//  UIVewControllerExtensions.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 08/07/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

extension UIViewController {
    func hideEmptyRows(_ _table: UITableView){
        let tblView =  UIView(frame: CGRect.zero)
        _table.tableFooterView = tblView
        _table.tableFooterView!.isHidden = true
        _table.backgroundColor = UIColor.clear
    }
    
    func setBackgroundImage(_ name:String, ofType:String){
        UIGraphicsBeginImageContext(self.view.frame.size)
        let image = UIImage(contentsOfFile: Bundle.main.path(forResource: name, ofType: ofType)!)
        image?.draw(in: self.view.bounds)
        let i = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor(patternImage: i!)
    }
}
