//
//  CurveShapeView.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/2/29.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class CurveShapeView: UIView {
    
    private let leftRadius: CGFloat = 100
    private let rightRadius: CGFloat = 50
    
    var shapeColor: UIColor = .gray {
        didSet {
            shapeLayer.fillColor = shapeColor.cgColor
        }
    }
    
    private let shapeLayer = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath()
        
        let startPoint = CGPoint(x: 0, y: 0)
        let leftEdge = CGPoint(x: 0, y: rect.maxY)
        let leftPoint = CGPoint(x: leftRadius, y: rect.maxY - leftRadius)
        let rightPoint = CGPoint(x: rect.maxX - rightRadius, y: rect.maxY - leftRadius)
        let rightEdge = CGPoint(x: rect.maxX, y: rect.maxY - leftRadius - rightRadius)
        let endPoint = CGPoint(x: rect.maxX, y: 0)
        
        path.move(to: startPoint)
        path.addLine(to: leftEdge)
        path.addQuadCurve(to: leftPoint, controlPoint: CGPoint(x: 0, y: rect.maxY - leftRadius))
        path.addLine(to: rightPoint)
        path.addQuadCurve(to: rightEdge, controlPoint: CGPoint(x: rect.maxX, y: rect.maxY - leftRadius))
        path.addLine(to: endPoint)
        path.close()
        
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = shapeColor.cgColor
        layer.addSublayer(shapeLayer)
        
        self.backgroundColor = .clear
    }
}
