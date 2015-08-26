//
//  AICalendarViewController.swift
//  AI2020OS
//
//  Created by tinkl on 22/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

class AICalendarViewController: UIViewController,CVCalendarViewDelegate {
    
    
    // MARK: swift controls
    
    @IBOutlet weak var containerView: SpringView!
    
    @IBOutlet weak var calendarView: CVCalendarView!
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var startDateButton: UIButton!
    
    @IBOutlet weak var endDateButton: UIButton!
    
    // MARK: variables
    
    private var selectIndex:Int = 0
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.monthLabel.text = CVDate(date: NSDate()).description()
        
        selected(self.startDateButton)
        disSelected(self.endDateButton)
        
        
        spring(0.5, {
            self.calendarView.alpha = 1
            self.menuView.alpha = 1
            
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        spring(0.3, {
            self.calendarView.commitCalendarViewUpdate()
            self.menuView.commitMenuViewUpdate()
            
        })
        
    }
    
    // MARK: event response
    
    @IBAction func startDownAtion(sender: AnyObject) {
        selectIndex = 0
        selected(self.startDateButton)
        disSelected(self.endDateButton)
    }
    
    @IBAction func endDownAtion(sender: AnyObject) {
        selectIndex = 1
        selected(self.endDateButton)
        disSelected(self.startDateButton)
    }
    
    
    func disSelected(buttonS: UIButton?){
        if var button = buttonS{
            
            // TODO: title Color
            button.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
            
            // TODO: Background Image
            button.setBackgroundImage(UIColor.whiteColor().imageWithColor(), forState: UIControlState.Normal)
            button.setBackgroundImage(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).imageWithColor(), forState: UIControlState.Selected)
            button.setBackgroundImage(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).imageWithColor(), forState: UIControlState.Highlighted)
            
            
        }
    }
    
    func selected(buttonS: UIButton?){
        if var button = buttonS{
            
            // TODO: title Color
            button.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forState: UIControlState.Selected)
            button.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forState: UIControlState.Highlighted)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            
            // TODO: Background Image
            button.setBackgroundImage(UIColor.whiteColor().imageWithColor(), forState: UIControlState.Normal)
            button.setBackgroundImage(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).imageWithColor(), forState: UIControlState.Normal)
            button.setBackgroundImage(UIColor.whiteColor().imageWithColor(), forState: UIControlState.Highlighted)
            
        }
    }
    
    @IBAction func dismissCurrentViewAction(sender: AnyObject) {
        
        
        self.containerView.animation = "zoomOut"
        self.containerView.animate()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func todayMonthView() {
        self.calendarView.toggleTodayMonthView()
    }
    
    
    // MARK: Calendar View Delegate
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        // TODO:
        
        
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> UIColor {
        if dayView.date?.day == 3 {
        }
        return .redColor()
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        if dayView.date?.day == 3 || dayView.date?.day == 15 || dayView.date?.day == 22 {
            return true
        } else {
            return false
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    
    func presentedDateUpdated(date: CVDate) {
        
        self.monthLabel.text = date.description
       
    }
    
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        let calendarManager = CVCalendarManager.sharedManager
        let components = calendarManager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleMonthViewWithDate(resultDate)
    }
}