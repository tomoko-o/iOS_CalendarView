//
//  CalendarView.swift
//  CalendarView
//
//  Created by Tomoko Ogawa on 2015/02/25.
//  Copyright (c) 2015年 Tomoko Ogawa. All rights reserved.
//

import UIKit
import Foundation

@objc protocol CalendarViewDelegate {
    optional func clickBackBtn(calendarView: CalendarView, year: Int, month: Int)
    optional func clickNextBtn(calendarView: CalendarView, year: Int, month: Int)
    optional func clickDay(calendarView: CalendarView, year: Int, month: Int, day: Int)
}

class CalendarView: UIView {

    var delegate :CalendarViewDelegate? = nil

    private let TAB_SIZE: CGFloat = 49.0
    private let STATUSBAR_HEIGHT: CGFloat = 20.0
    private let MONTH_LABEL_HEIGHT: CGFloat = 60.0
    private let WEEKDAY_HEIGHT: CGFloat = 24.0
    private let AD_HEIGHT: CGFloat = 40.0
    
    private let SUBVIEW_YEARMONTH = 0
    private let SUBVIEW_MONTHLY = 2
    
    private var year = 0
    private var month = 0
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect, year: Int, month: Int){

        super.init(frame: frame)
        
        self.year = year
        self.month = month
    
        self.addSubview(createCalendarView(frame: frame, year: year, month: month))
        
        self.setMonthly(year: year, month: month)

    }

    private func createCalendarView(#frame: CGRect, year: Int, month: Int) -> UIView{
        let calendarView = UIView(frame: frame)
        
        let frameSize = frame.size
        var yOffset: CGFloat = STATUSBAR_HEIGHT
        
        //****************************
        // 年月のViewをセットする
        //
        let now = NSDate()
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth, fromDate: now)
        
        calendarView.addSubview(createYearMonthView(frameSize: frameSize, y: yOffset, year: year, month: month))
        
        //****************************
        // 曜日のViewをセットする
        //
        yOffset += MONTH_LABEL_HEIGHT
        calendarView.addSubview(createWeekdayView(frameSize: frameSize, y: yOffset))
        
        
        //****************************
        // 日付のViewをセットする
        //
        yOffset += WEEKDAY_HEIGHT
        calendarView.addSubview(createMonthlyView(frameSize: frameSize, yOffset: yOffset))
        
//        self.setMonthly(year: components.year, month: components.month)

        return calendarView
    }
    
    private func createYearMonthView(#frameSize: CGSize, y: CGFloat, year: Int, month: Int) -> UIView {
        let yearMonthView = UIView(frame: CGRect(x: 0, y: y, width: frameSize.width, height: MONTH_LABEL_HEIGHT))
        
        let width = frameSize.width / 3
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: MONTH_LABEL_HEIGHT))
        backButton.setTitle("<<", forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        backButton.addTarget(self, action: "touchBackBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        yearMonthView.addSubview(backButton)
        
        let yearMonthLabel = UILabel(frame: CGRect(x: backButton.frame.maxX, y: 0, width: width, height: MONTH_LABEL_HEIGHT))
        yearMonthLabel.textAlignment = NSTextAlignment.Center
        yearMonthView.addSubview(yearMonthLabel)
        
        let nextButton = UIButton(frame: CGRect(x: yearMonthLabel.frame.maxX, y: 0, width: width, height: MONTH_LABEL_HEIGHT))
        nextButton.setTitle(">>", forState: UIControlState.Normal)
        nextButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        nextButton.addTarget(self, action: "touchNextBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        yearMonthView.addSubview(nextButton)
        
        return yearMonthView
    }
    private func createWeekdayView(#frameSize: CGSize, y:CGFloat) -> UIView {
        let weekdayText = ["日", "月", "火", "水", "木", "金", "土"]
        let weekdayView = UIView(frame: CGRect(x: 0, y: y, width: frameSize.width, height: WEEKDAY_HEIGHT))
        
        let width: CGFloat = frameSize.width / 7
        
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        for i in 0..<7 {
            let weekdayLabel = UILabel(frame: CGRect(x: x, y: 0, width: width, height: WEEKDAY_HEIGHT))
            weekdayLabel.text = weekdayText[i]
            weekdayLabel.textAlignment = NSTextAlignment.Center
            weekdayLabel.layer.borderColor = UIColor.blackColor().CGColor
            weekdayLabel.layer.borderWidth = 0.5
            
            let rec = UITapGestureRecognizer(target: self, action: "touchDay:")
            weekdayLabel.userInteractionEnabled = true
            weekdayLabel.addGestureRecognizer(rec)
            weekdayLabel.tag = i
            
            weekdayView.addSubview(weekdayLabel)
            x += width
        }
        
        return weekdayView
    }
    
    private func createMonthlyView(#frameSize: CGSize, yOffset: CGFloat) -> UIView {
        
        let monthlyView = UIView(frame: CGRect(x: 0, y: yOffset, width: frameSize.width, height: frameSize.height - yOffset))
        //        monthlyView.backgroundColor = UIColor.blackColor()
        monthlyView.tag = 999
        
        let height: CGFloat = (frameSize.height - yOffset) / 6
        let width: CGFloat = frameSize.width / 7
        
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        for week in 1...6 {
            let weeklyView = UIView(frame: CGRect(x: 0, y: y, width: frameSize.width, height: height))
            weeklyView.tag = 555
            for i in 1...7 {
                var dayView = UIView(frame: CGRect(x: x, y: 0, width: width, height: height))
                dayView.layer.borderWidth = 0.5
                dayView.layer.borderColor = UIColor.blackColor().CGColor
                
                let dayLabel = UILabel(frame: CGRect(x: 4, y: 4, width: width, height: 20))
                dayView.addSubview(dayLabel)
                
                weeklyView.addSubview(dayView)
                
                let recognizer = UITapGestureRecognizer(target: self, action: "touchDay:")
                dayView.userInteractionEnabled = true
                dayView.addGestureRecognizer(recognizer)
                
                x += width
            }
            monthlyView.addSubview(weeklyView)
            y += height
            x = 0.0
        }
        
        return monthlyView
    }
    
    func setMonthly(#year: Int, month: Int){
        self.setYearMonth(year: year, month: month)
        self.setDay(year: year, month: month)
    }
    
    private func setYearMonth(#year: Int, month: Int){
        let view = self.subviews[0] as UIView
        let title = self.subviews[0].subviews[SUBVIEW_YEARMONTH].subviews[1] as UILabel
        
        title.text = "\(year)年\(month)月"
    }
    
    private func setDay(#year: Int, month: Int){
        let calendarData = CalendarData(year: year, month: month)
        let calendarMatrix = calendarData.calendarMatrix
        
        let monthlyView = self.subviews[0].subviews[SUBVIEW_MONTHLY] as UIView

        for i in 0...5 {
            let weeklyView = monthlyView.subviews[i] as UIView
            for j in 0...6 {
                let dayView = weeklyView.subviews[j] as UIView
                dayView.tag = calendarMatrix[i][j]
                let dayLabel = weeklyView.subviews[j].subviews[0] as UILabel
                dayLabel.text = String(abs(calendarMatrix[i][j]))
                dayLabel.tag = calendarMatrix[i][j]
            }
        }
    }
    
    func touchBackBtn(sender: AnyObject){
        
        if month == 1 {
            month = 12
            year--
        }else{
            month--;
        }
        setMonthly(year: year, month: month)
        
        self.delegate?.clickBackBtn?(self, year: year, month: month)
    }
    
    func touchNextBtn(sendar: AnyObject){
        
        if month == 12 {
            month = 1
            year++
        }else{
            month++
        }
        setMonthly(year: year, month: month)
        
        self.delegate?.clickNextBtn?(self, year: year, month: month)
    }
    
    func touchDay(sender: UITapGestureRecognizer){
        let day = sender.view?.tag
        
        if day == 0 {
            return
        }
        
        var selectDay: Int = abs(day!)
        var selectYear = year
        var selectMonth = month
        
        //翌月
        if day < 0 && day > -20 {
            if month == 12 {
                selectMonth = 1
                selectYear++
            }else{
                selectMonth++
            }
            
        //前月
        }else if day < -20 {
            if month == 1 {
                selectMonth = 12
                selectYear--
            }else{
                selectMonth--
            }
        }
//        
//        println("\(selectYear)/\(selectMonth)/\(selectDay)")
        
        self.delegate?.clickDay?(self, year: selectYear, month: selectMonth, day: selectDay)
    }
    
}
