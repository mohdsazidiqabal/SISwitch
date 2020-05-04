//
//  SISwitch.swift
//  SISwitch
//
//  Created by Mohd Sazid Iqabal on 03/05/20.
//  Copyright © 2020 Sazid. All rights reserved.
//

import UIKit

@IBDesignable
class SISwitch: UIView {
    
    private var circleThumbLayer: CAShapeLayer?
    private var paddingWidth: CGFloat = 0.0
    private var circleThumbRadius: CGFloat = 0.0
    private var moveDistance: CGFloat = 0.0
    private var thumbLayerWidth: CGFloat = 0.0
    private var isAnimating = false
    private var isOn = false

    
    /// Customizable Properties
    
    private var animationDuration: CGFloat = 1.2
    private var thumbOnColor: UIColor? = .white
    private var thumbOfColor: UIColor? = .white
    private var offColor: UIColor? = UIColor.darkGray
    private var onColor: UIColor? = UIColor.red
    
    /// Set the Animation Duration
    @IBInspectable var durationAnimation: CGFloat {
        get {
            return animationDuration
        }
        set(duration) {
            animationDuration = duration
        }
    }
    
    
    /// Set Thumb color for On State
    @IBInspectable var onThumbColor: UIColor? {
        get {
            return thumbOnColor
        }
        set(thumbColor) {
            thumbOnColor = thumbColor
        }
    }
    
    
    
    /// Set Thumb color for Off State
    @IBInspectable var offThumbColor: UIColor? {
        get {
            return thumbOfColor
        }
        set(offColor) {
            thumbOfColor = offColor
            circleThumbLayer?.fillColor = offColor?.cgColor
        }
    }
    
    
    /// Set switch background color for Off state
    @IBInspectable var bgOffColor: UIColor? {
        get {
            return offColor
        }
        set(colorOff) {
            self.offColor = colorOff
            if !isOn {
                self.backgroundColor = colorOff
            }
        }
    }
    
    /// Set switch background color for On state
    @IBInspectable var bgOnColor: UIColor? {
        get {
            return onColor
        }
        set(colorOn) {
            self.onColor = colorOn
            if isOn {
                self.backgroundColor = colorOn
            }
        }
    }
    
    
    private var circleThumbLayerInit: CAShapeLayer? {
        if circleThumbLayer == nil {
            circleThumbLayer = CAShapeLayer()
            circleThumbLayer?.frame = CGRect(x: paddingWidth, y: paddingWidth, width: circleThumbRadius * 2, height: circleThumbRadius * 2)
            let circlePath = UIBezierPath(ovalIn: circleThumbLayer!.bounds)
            circleThumbLayer?.path = circlePath.cgPath
            if let circleThumbLayer = circleThumbLayer {
                self.layer.addSublayer(circleThumbLayer)
            }
        }
        return circleThumbLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetup()
    }
    
}
extension SISwitch:  CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print(#function)
        if isOn {
            circleThumbLayer?.position = CGPoint(x: circleThumbLayer!.position.x - moveDistance, y: circleThumbLayer!.position.y)
        } else {
            circleThumbLayer?.position = CGPoint(x: circleThumbLayer!.position.x + moveDistance, y: circleThumbLayer!.position.y)
        }
        isOn = !isOn
        isAnimating = false
    }
}

extension SISwitch {
    
    func initialSetup() {
        self.backgroundColor = offColor
        self.layer.cornerRadius = self.frame.height/2
        paddingWidth = frame.size.height * 0.1
        circleThumbRadius = (frame.size.height - 2 * paddingWidth) / 2
        moveDistance = frame.size.width - paddingWidth * 2 - circleThumbRadius * 2
        circleThumbLayerInit?.fillColor = UIColor.white.cgColor
        thumbLayerWidth = circleThumbLayer!.frame.size.width
        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapSwitch)))
    }
    
    @objc func handleTapSwitch() {
        print(#function)
        if isAnimating {
            return
        }
        isAnimating = true
        moveAnimation()
        colorAnimation()
    }
    
    
    func moveAnimation() {
        let fromPosition  = circleThumbLayer!.position
        let toPosition = isOn ? CGPoint(x: circleThumbLayer!.position.x - moveDistance, y: circleThumbLayer!.position.y) : CGPoint(x: circleThumbLayer!.position.x + moveDistance, y: circleThumbLayer!.position.y)
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = NSValue(cgPoint: fromPosition)
        moveAnimation.toValue = NSValue(cgPoint: toPosition)
        moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        moveAnimation.duration = CFTimeInterval(animationDuration * 2 / 3)
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.fillMode = .forwards
        moveAnimation.delegate = self
        circleThumbLayer?.add(moveAnimation, forKey: "SIThumbMovementAnimationKey")
        self.circleThumbLayerInit?.fillColor = self.isOn ? self.thumbOfColor?.cgColor : self.thumbOnColor?.cgColor
        
    }
    
    func colorAnimation() {
        let fromValue = (isOn ? onColor : offColor)?.cgColor
        let toValue = (isOn ? offColor : onColor)?.cgColor
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = fromValue
        colorAnimation.toValue = toValue
        colorAnimation.duration = CFTimeInterval(animationDuration * 2 / 3)
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.fillMode = .forwards
        self.layer.add(colorAnimation, forKey: "SIBgColorAnimationKey")
    }
}

