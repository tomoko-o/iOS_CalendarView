//
//  ViewController.swift
//  CalendarView
//
//  Created by Tomoko Ogawa on 2015/02/20.
//  Copyright (c) 2015年 Tomoko Ogawa. All rights reserved.
//

import UIKit
import Foundation

class CalendarViewController: UIViewController, CalendarViewDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var frame = UIScreen.mainScreen().applicationFrame
        println(frame)
        println(UIScreen.mainScreen().bounds)
//        frame.origin.y = 

        let calendarView = CalendarView(frame: frame, year: 2015, month: 2)
        calendarView.delegate = self
        self.view.addSubview(calendarView)
        
//        calendarView.setMonthly(year: 2015, month: 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func clickDay(calendarView: CalendarView, year: Int, month: Int, day: Int) {
        
        println("\(year)/\(month)/\(day)")
    }
}

