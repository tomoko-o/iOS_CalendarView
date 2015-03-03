//
//  CalendarData.swift
//  CalendarView
//
//  Created by Tomoko Ogawa on 2015/02/25.
//  Copyright (c) 2015年 Tomoko Ogawa. All rights reserved.
//

import Foundation

class CalendarData {
    
    var calendarMatrix:[[Int]] = [[Int]](count: 6, repeatedValue: [Int](count: 7, repeatedValue: 0))
    
    init(year: Int, month: Int){
        
        // 1ヶ月の日付を生成
        let comps = NSDateComponents()
        comps.year = year
        comps.month = month
        comps.day = 1
        
        let cal = NSCalendar.currentCalendar()
        var thisMonth = cal.dateFromComponents(comps)!
        var backMonth = cal.dateFromComponents(comps)!
        
        let range = cal.rangeOfUnit(NSCalendarUnit.DayCalendarUnit, inUnit: NSCalendarUnit.MonthCalendarUnit, forDate: thisMonth)
        let lastDay = range.length

        // 加減算用
        let compsDay = NSDateComponents()
        compsDay.day = 1

        //月初の曜日を取得（日=1）
        let compsWeekday = cal.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: thisMonth)
        let weedDay = compsWeekday.weekday
        
        // 前月の日付
        if weedDay > 1 {
            compsDay.day = -1
            for var i = (weedDay - 1); i > 0; i-- {
                backMonth = cal.dateByAddingComponents(compsDay, toDate: backMonth, options: nil)!
                let compsBackDay = cal.components(NSCalendarUnit.CalendarUnitDay, fromDate: backMonth)
                calendarMatrix[0][i - 1] = -compsBackDay.day
            }
        }
        
        // 当月/翌月の日付
        var i = weedDay - 1
        var nextMonthFlg = false
        let compsThisDay = cal.components(NSCalendarUnit.CalendarUnitDay, fromDate: thisMonth)
        compsDay.day = 1
        for var week = 0; week < 6; week++ {
            while i < 7 {
                let day = cal.components(NSCalendarUnit.CalendarUnitDay, fromDate: thisMonth).day
                if nextMonthFlg {
                    calendarMatrix[week][i] = -day
                }else{
                    calendarMatrix[week][i] = day
                }
                if day == lastDay{
                    nextMonthFlg = true
                }
                
                thisMonth = cal.dateByAddingComponents(compsDay, toDate: thisMonth, options: nil)!
                i++
            }
            
            i = 0;
        }

    }
    
}