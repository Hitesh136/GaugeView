//
//  NeddleView.swift
//  GaugeView
//
//  Created by Hitesh Agarwal on 23/07/19.
//  Copyright © 2019 Finoit Technologies. All rights reserved.
//

import UIKit
enum NeedleType {
    case seconds
    case minutes
    case hours
}

class NeedleView: UIView {
    
    var centerPoint = CGPoint(x: 0, y: 0)
    var radius: CGFloat = 1
    var bottomLineHeight: CGFloat = 30
    var topLineHeight: CGFloat = 0
    var lineWidth: CGFloat = 2
    var lineColor = UIColor.orange
    var needleType: NeedleType = .seconds
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        bottomLineHeight = rect.height * 0.08
        radius = lineWidth * 2
        centerPoint.x = rect.midX
        centerPoint.y = rect.midY  
        topLineHeight = centerPoint.y - radius - (lineWidth / 2)
        drawCircle(inRect: rect, context: ctx)
        drawBottomLine(inRect: rect, context: ctx)
        drawTopLine(inRect: rect, context: ctx)
    }
    
    
    func drawCircle(inRect rect: CGRect,context ctx: CGContext) {
        ctx.saveGState()
        ctx.translateBy(x: centerPoint.x, y: centerPoint.y)
        ctx.rotate(by: deg2rad(0))
        
        lineColor.set()
        ctx.setLineWidth(lineWidth)
        ctx.addArc(center: .zero, radius: radius, startAngle: deg2rad(0), endAngle: deg2rad(360), clockwise: false)
        ctx.drawPath(using: .stroke)
        ctx.restoreGState()
    }
    
    func drawBottomLine(inRect rect: CGRect, context ctx: CGContext) {
        ctx.saveGState()
        lineColor.set()
        ctx.setLineWidth(lineWidth)
        let startY = centerPoint.y + radius + (lineWidth / 2)
        let startX = centerPoint.x
        ctx.move(to: CGPoint(x: startX, y: startY))
        
        let endY = startY + bottomLineHeight
        ctx.addLine(to: CGPoint(x: startX, y: endY))
        ctx.drawPath(using: .stroke)
        ctx.restoreGState()
    }
    
    func drawTopLine(inRect rect: CGRect, context ctx: CGContext) {
        ctx.saveGState()
        
        lineColor.set()
         ctx.setLineWidth(lineWidth)
        
        var startY: CGFloat
        switch needleType {
            case .seconds:
            startY = 0
        case .minutes:
            startY = rect.height * 0.10
        case .hours:
            startY = rect.height * 0.26
        }
        let startX = centerPoint.x
        ctx.move(to: CGPoint(x: startX, y: startY))
        
        let endY = topLineHeight
        ctx.addLine(to: CGPoint(x: startX, y: endY))
        ctx.drawPath(using: .stroke)
        ctx.restoreGState()
    }
}
