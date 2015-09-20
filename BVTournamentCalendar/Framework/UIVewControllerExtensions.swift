//
//  UIVewControllerExtensions.swift
//  BVTournamentCalendar
//
//  Created by Carl Kenne on 08/07/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

extension UIViewController {
    func hideEmptyRows(_table: UITableView){
        let tblView =  UIView(frame: CGRectZero)
        _table.tableFooterView = tblView
        _table.tableFooterView!.hidden = true
        _table.backgroundColor = UIColor.clearColor()
    }
    
    func setBackgroundImage(name:String, ofType:String){
        UIGraphicsBeginImageContext(self.view.frame.size)
        let image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource(name, ofType: ofType)!)
        image?.drawInRect(self.view.bounds)
        let i = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor(patternImage: i)
    }
}