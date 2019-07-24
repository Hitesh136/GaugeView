//
//  GaugeView.swift
//  DBG
//
//  Created by Hitesh Agarwal on 10/07/19.
 
//

import Foundation
import UIKit


func deg2rad(_ number: CGFloat) -> CGFloat {
    return number * .pi / 180
}

class GaugeView: UIView {

    var centerPoint: CGPoint = .zero
    let margin: CGFloat = 0
    let defaultColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
    let totalAngle: CGFloat = 360
    let initialAngle: CGFloat = 0
    let marginAngle: CGFloat = 15
    let totalTicksCount = 240
    let labelMargin: CGFloat = 0
    let tickWidth: CGFloat = 2
    let largerTickLength: CGFloat = 15
    let mediumTickLength: CGFloat = 10
    
    var secondsNeedleView: NeedleView? = nil
    var minutesNeedleView: NeedleView? = nil
    var hoursNeedleView: NeedleView? = nil
    
    let needleY: CGFloat = 0.0
    let needleWidth: CGFloat = 15.0
    var min: CGFloat = 0
    var max: CGFloat = 60
    
    let labelLength: CGFloat = 50.0
    let labelWidth: CGFloat = 10
    let labelsTitles = ["12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11 "]
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        
        
        drawCenter(in: rect, context: ctx)
        drawTicks(in: rect, context: ctx)
        drawLabels(in: rect, context: ctx) 
        drawneedle(in: rect, context: ctx)
    }
    
    func drawCenter(in rect: CGRect, context ctx: CGContext) {
        let centerView = UIView()
        centerView.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        centerView.layer.cornerRadius = 2.5
        centerView.backgroundColor = UIColor.clear
        centerView.center = centerPoint
        addSubview(centerView)
    }

    func drawTicks(in rect: CGRect, context ctx: CGContext) {
        //Draw larger lines
        ctx.saveGState()
        ctx.translateBy(x: centerPoint.x, y: centerPoint.y)
        ctx.rotate(by: deg2rad(initialAngle))
        UIColor.black.set()
        
        let radius = centerPoint.y - margin
        let segmentAngle = deg2rad(totalAngle / CGFloat(totalTicksCount))
        
        for i in 0...totalTicksCount {
            defaultColor.set()
            var majorEnd: CGFloat = 0
            var majorStart: CGFloat = 0
            
            if i % 4 == 0 {
                if i % 5 == 0 {
                    UIColor.white.set()
                }
                majorStart = radius
                majorEnd = majorStart - largerTickLength
                ctx.setLineWidth(tickWidth)
                ctx.move(to: CGPoint(x: majorStart, y: 0))
                ctx.addLine(to: CGPoint(x: majorEnd, y: 0))
            } else {
                majorStart = radius
                majorEnd = majorStart - mediumTickLength
                ctx.setLineWidth(tickWidth)
                ctx.move(to: CGPoint(x: majorStart, y: 0))
                ctx.addLine(to: CGPoint(x: majorEnd, y: 0))
            }
            
            ctx.drawPath(using: .stroke)
            ctx.rotate(by: segmentAngle)
        }
        ctx.restoreGState()
    }

    func drawLabels(in rect: CGRect, context ctx: CGContext) {
        var startTime = 0
        for i in 0..<totalTicksCount where i % 5 == 0 && i % 4 == 0 {
            
            let angle = ((totalAngle / CGFloat(totalTicksCount)) * CGFloat(i)) + initialAngle - 90
            let radius = centerPoint.y - margin - largerTickLength - labelMargin - (labelLength / 2)
            let centerX = centerPoint.x + radius * cos(deg2rad(angle)) - (tickWidth / 2)
            let centerY = centerPoint.y + radius * sin(deg2rad(angle)) - (tickWidth / 2)

//            let text = String(startTime)
            var text = "00"
            if (0..<labelsTitles.count).contains(startTime) {
                text = labelsTitles[startTime]
            }
            let textFont = UIFont.systemFont(ofSize: 25)
            let textHeight = text.height(withConstrainedWidth: labelLength, font: textFont)
            let textWidth = text.width(withConstrainedHeight: labelLength, font: textFont)
            let frame = CGRect(x: 0, y: 0, width: textWidth, height: textHeight)
            let label = UILabel(frame: frame)
            label.text = text
            label.textColor = UIColor.white
            label.center = CGPoint(x: centerX, y: centerY)
            label.font = textFont
            startTime += 1
            
            
            addSubview(label)
            
//            let anchorPoint = CGPoint(x: startX, y: startY + (largerTickWidth / 2))
//            label.layer.anchorPoint = anchorPoint
//            label.setAnchorPoint(CGPoint(x: 0, y: 0.5))
//
//            print(angle)
//            label.transform = CGAffineTransform(rotationAngle: deg2rad(angle))
        }
    }
    
    func drawneedle(in rect: CGRect, context ctx: CGContext) {
        
        if secondsNeedleView == nil {
            secondsNeedleView = NeedleView()
            secondsNeedleView?.needleType = .seconds
            let needleX = centerPoint.x - (needleWidth / 2)

            secondsNeedleView!.frame = CGRect(x: needleX, y: 0, width: needleWidth, height: rect.height)
            secondsNeedleView?.backgroundColor = UIColor.clear
            addSubview(secondsNeedleView!)
            secondsNeedleView?.setNeedsDisplay()
        }
        
        if minutesNeedleView == nil {
            minutesNeedleView = NeedleView()
            minutesNeedleView?.needleType = .minutes
            let needleX = centerPoint.x - (needleWidth / 2)
            minutesNeedleView!.frame = CGRect(x: needleX, y: 0, width: needleWidth, height: rect.height)
            minutesNeedleView?.backgroundColor = UIColor.clear
            addSubview(minutesNeedleView!)
            minutesNeedleView?.setNeedsDisplay()
        }

        if hoursNeedleView == nil {
            hoursNeedleView = NeedleView()
            hoursNeedleView?.needleType = .hours
            let needleX = centerPoint.x - (needleWidth / 2)
            hoursNeedleView!.frame = CGRect(x: needleX, y: 0 , width: needleWidth, height: rect.height)
            hoursNeedleView?.backgroundColor = UIColor.clear
            addSubview(hoursNeedleView!)
            hoursNeedleView?.setNeedsDisplay()
        }
        
    }
//
    var value: String = "" {
        didSet {
            let time = value.components(separatedBy: ":").map{ Int($0) ?? 0 }
            guard time.count == 3 else {
                return
            }
            hoursValue = time[0]
            minutesValue = time[1]
            secondValue = time[2]
        }
    }
    
    var secondValue: Int = 0 {
        didSet {
            guard let needleView = secondsNeedleView else {
                return
            }
            let valueM = CGFloat(secondValue) / CGFloat(max)
            let pos = totalAngle * CGFloat(valueM)
            needleView.transform = CGAffineTransform(rotationAngle: deg2rad(pos))
        }
    }
    
    var minutesValue: Int = 0 {
        didSet {
            guard let needleView = minutesNeedleView else {
                return
            }
            let valueM = CGFloat(minutesValue) / CGFloat(max)
            let pos = totalAngle * CGFloat(valueM)
            needleView.transform = CGAffineTransform(rotationAngle: deg2rad(pos))
        }
    }
    
    var hoursValue: Int = 0 {
        didSet {
            guard let needleView = hoursNeedleView else {
                return
            }
            let valueM = CGFloat(hoursValue) / CGFloat(12)
            let pos = totalAngle * CGFloat(valueM)
            
            let minutesShift:CGFloat = (CGFloat(minutesValue) / 60.0) * 30.0
            
            needleView.transform = CGAffineTransform(rotationAngle: deg2rad(pos + minutesShift))
        }
    }
//
//    func drawLabels(in rect: CGRect, context ctx: CGContext) {
//        ctx.saveGState()
//        ctx.translateBy(x: rect.midX, y: rect.midY)
//        ctx.rotate(by: deg2rad(rotation))
        
//        let circleRadius = (((rect.width - segmentWidth) / 2) - outerBezelWidth)
//        let segmentAngle = totalAngle / CGFloat(40)
//
//        for i in 0..<40  {
//            let nameLabel = UILabel()
//            nameLabel.text = String(i)
//            let angle = segmentAngle * CGFloat(i)
//            let posX = rect.midX + (circleRadius * CGFloat(cos(Double(deg2rad(angle)))))
//            let posY = rect.maxY - (circleRadius * CGFloat(sin(Double(deg2rad(angle)))))
//
//
//            nameLabel.frame = CGRect(x: 0, y: 0, width: largerTickWidth, height: largerTickWidth)
////            nameLabel.frame.size = CGSize(width: largerTickWidth, height: largerTickWidth)
//            nameLabel.center = CGPoint(x: posX, y: posY)
//            nameLabel.backgroundColor = UIColor.red
//            print("Segment Angle: \(angle)")
//            addSubview(nameLabel)
//        }
////        ctx.restoreGState()
//    }
}


extension UILabel {
    func reSize(){
        var rect: CGRect = frame //get frame of label
        rect.size = (text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: font.fontName , size: font.pointSize)!]))! //Calculate as per label font
        self.frame.size = rect.size
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension UIView {

    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}
