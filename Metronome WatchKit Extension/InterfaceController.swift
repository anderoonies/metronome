//
//  InterfaceController.swift
//  Metronome WatchKit Extension
//
//  Created by Andy Bayer on 6/8/15.
//  Copyright © 2015 Andy Bayer. All rights reserved.
//

import WatchKit
import Foundation
import UIKit


class InterfaceController: WKInterfaceController {

    @IBOutlet var tempoLabel: WKInterfaceLabel!
    @IBOutlet var tempoSlider: WKInterfaceSlider!
    @IBOutlet var startStopButton: WKInterfaceButton!
    
    var tempo = 60 // bpm
    var spb :NSTimeInterval = 1 // seconds per beat
    var timer: NSTimer?
    var isOn :Bool?
        
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        isOn = false
        
        spb = NSTimeInterval(60 / Float(tempo))
        
        tempoSlider.setEnabled(true)
        
        updateLabel()
    }

    @IBAction func sliderAction(value: Float) {
        tempo = Int(value)
        updateLabel()
        updateTimer()
    }
    
    @IBAction func startStopButtonPressed() {
        if (isOn == true) {
            isOn = false
            let startString = "Start"
            startStopButton.setTitle(startString)
            timer?.invalidate()
        } else {
            isOn = true
            let stopString = "Stop"
            let attributedString = NSMutableAttributedString(string: stopString, attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            startStopButton.setAttributedTitle(attributedString)
            timer = NSTimer.scheduledTimerWithTimeInterval(spb, target: self, selector: Selector("tap"), userInfo: nil, repeats: true)
        }
    }
    
    func updateLabel() {
        tempoLabel.setText(String(tempo))
    }
    
    func updateTimer() {
        spb = NSTimeInterval(60 / Float(tempo))
        if (isOn == true) {
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(spb, target: self, selector: Selector("tap"), userInfo: nil, repeats: true)
        }
    }
    
    func tap() {
        print("hit! \(spb)")
        WKInterfaceDevice.currentDevice().playHaptic(WKHapticType.Click)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
