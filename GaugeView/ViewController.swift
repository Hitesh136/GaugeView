//
//  ViewController.swift
//  GaugeView
//
//  Created by Hitesh Agarwal on 23/07/19.
//  Copyright © 2019 Finoit Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var clockView: GaugeView!
    var dateFormatter: DateFormatter? = nil
    
    var second: Int = 0 {
        didSet {
            clockView.secondValue = second
        }
    }
    var timer: Timer? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runClock()
    }

    func runClock() {
        let timerInterval = 1.0
        timer?.invalidate()
        let date = Date()
        let dateFormatter1 = DateFormatter()
        let dateFormat = "HH:mm:SS"
        dateFormatter1.dateFormat = dateFormat
        let dateString = dateFormatter1.string(from: date)
        let time = dateString.components(separatedBy: ":").map{ Int(String($0)) ?? 0 }
        
        second = time[2]
        clockView.minutesValue = time[1]
        clockView.hoursValue = time[0]
        
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { (timer) in
            self.second += 1
            if self.second % 60 == 0 {
                self.second = 0
                self.clockView.minutesValue += 1
                
                if self.clockView.minutesValue % 60 == 0 {
                    self.clockView.minutesValue = 0
                    self.clockView.hoursValue += 1
                }
            }             
        }
        timer?.fire()
    }
    
}

