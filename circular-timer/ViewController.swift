//
//  ViewController.swift
//  circular-timer
//
//  Created by Emre Ihlamur on 7.11.2018.
//  Copyright © 2018 ihlamur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let circleShapeLabel = CAShapeLayer()
    var isStarted = false
    
    //init timer
    var timer = Timer()
    var remainingTime = 20
    let totalTime = 20
    
    //init label
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init path
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 70, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        //Draw the Circle
        circleShapeLabel.path = circularPath.cgPath
        circleShapeLabel.strokeColor = UIColor(red:0.33, green:0.90, blue:0.76, alpha:1.0).cgColor
        circleShapeLabel.lineWidth = 10
        circleShapeLabel.strokeEnd = 0
        circleShapeLabel.lineCap = CAShapeLayerLineCap.round
        circleShapeLabel.fillColor = UIColor(red:0.70, green:0.22, blue:0.44, alpha:1.0).cgColor
        circleShapeLabel.position = view.center
        circleShapeLabel.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        //add layers to view
        view.layer.addSublayer(circleShapeLabel)
        view.addSubview(timeLabel)
        
        //place label
        timeLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        timeLabel.center = view.center
        
        //add gesture recognizer to view
        view.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapGestureRecognizer)))
    }
    
    //Create Time Label
    private func setTimeLabel () {
        let minute = Int(floor(Double(remainingTime) / 60))
        let second = remainingTime - (minute * 60)
        
        var minuteStr = String(minute)
        var secondStr = String(second)
        
        if (minute < 10) {
            minuteStr = "0" + minuteStr
        }
        
        if (second < 10) {
            secondStr = "0" + secondStr
        }
        
        timeLabel.text = minuteStr + ":" + secondStr
    }
    
    //Timer Tick
    @objc func startTicking() {
        if (remainingTime == 0) {
            timer.invalidate()
            timeLabel.text = "End"
        } else {
            remainingTime = remainingTime - 1
            setTimeLabel()
        }
    }
    
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    
    var pausedTime: CFTimeInterval?
    
    //Animate()
    private func animateCircle() {
        setTimeLabel()
        if pausedTime != nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startTicking), userInfo: nil, repeats: true)
            let pausedTime = circleShapeLabel.timeOffset
            circleShapeLabel.speed = 1.0
            circleShapeLabel.timeOffset = 0.0
            circleShapeLabel.beginTime = 0.0
            let timeSincePause = circleShapeLabel.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            circleShapeLabel.beginTime = timeSincePause
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startTicking), userInfo: nil, repeats: true)
            basicAnimation.toValue = 1
            basicAnimation.duration = CFTimeInterval(totalTime)
            basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            basicAnimation.isRemovedOnCompletion = false
            circleShapeLabel.add(basicAnimation, forKey: "basic")
        }
    }
    
    @IBOutlet weak var tapToStartLabel: UILabel!
    
    //Tap Gesture Recognizer to Start or Pause Timer
    @objc private func tapGestureRecognizer() {
        if (!isStarted) {
            isStarted = true
            tapToStartLabel.text = "Tap to Pause"
            animateCircle()
        } else {
            pausedTime = circleShapeLabel.convertTime(CACurrentMediaTime(), from: nil)
            circleShapeLabel.speed = 0.0
            circleShapeLabel.timeOffset = pausedTime!
            isStarted = false
            tapToStartLabel.text = "Tap to Start"
            timer.invalidate()
        }
    }
    
    //Make Status Bar .lightContent
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
