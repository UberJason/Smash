//
//  WarmupInterfaceController.swift
//  SmashWatch Extension
//
//  Created by Jason Ji on 11/20/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import WatchKit
import Foundation
import SmashKitWatch

class WarmupInterfaceController: WKInterfaceController {

    var timer: Timer?
    
    @IBOutlet weak var calorieLabel: WKInterfaceLabel!
    @IBOutlet weak var elapsedTimeLabel: WKInterfaceLabel!
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    
    lazy var elapsedTimeFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.zeroFormattingBehavior = .pad
        f.allowedUnits = [.hour, .minute, .second]
        return f
    }()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        WorkoutManager.shared.startOrResumeWorkout()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateWorkoutStats), userInfo: nil, repeats: true)
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func endWarmup() {
        WorkoutManager.shared.pauseWorkoutIfNeeded()
        timer?.invalidate()
        dismiss()
    }
    
    @objc func updateWorkoutStats() {
        let heartRateText = WorkoutManager.shared.heartRate == -1 ? "--" : "\(WorkoutManager.shared.heartRate)"
        
        calorieLabel.setText("\(WorkoutManager.shared.calories) cal")
        elapsedTimeLabel.setText("\(elapsedTimeFormatter.string(from: WorkoutManager.shared.elapsedTime)!)")
        heartRateLabel.setText("\(heartRateText) BPM")
    }
}
