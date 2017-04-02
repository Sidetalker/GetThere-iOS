//
//  PaintedView.swift
//  GetThere
//
//  Created by Kevin Sullivan on 4/2/17.
//  Copyright © 2017 SideApps. All rights reserved.
//

import UIKit

enum Shape: String {
    case circle, triangle
}

@IBDesignable
public class PaintedView: UIView {
    
    @IBInspectable private(set) var shapeName: String? {
        get {
            return String(describing: shape)
        }
        set {
            if let state = Shape(rawValue: newValue?.lowercased() ?? "") {
                shape = state
            }
        }
    }
    
    @IBInspectable public var color: UIColor = .red { didSet { setNeedsDisplay() } }
    
    private(set) var shape: Shape = .circle
    
    public func rotate(to value: Float) {
        UIView.animate(withDuration: 2) {
            self.transform = CGAffineTransform(rotationAngle: CGFloat(value))
        }
    }

    override public func draw(_ rect: CGRect) {
        switch shape {
        case .circle:
            Paint.drawCircle(frame: rect, shapeFill: color)
        case .triangle:
            Paint.drawTriangle(frame: rect, resizing: .stretch, shapeFill: color)
        }
    }
}
