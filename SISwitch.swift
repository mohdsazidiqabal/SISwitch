//
//  SIViewController.swift
//  SISwitchDemo
//
//  Created by Mohd Sazid Iqabal on 03/05/20.
//  Copyright © 2020 Sazid. All rights reserved.

import UIKit

@IBDesignable
class SISwitch: UIView {
    private var circleFaceLayer: CAShapeLayer?
    private var paddingWidth: CGFloat = 0.0
    private var circleFaceRadius: CGFloat = 0.0
    private var moveDistance: CGFloat = 0.0
    private var faceLayerWidth: CGFloat = 0.0
    private var animationDuration: CGFloat = 1.2
    private var isAnimating = false
    private var faceOnColor: UIColor? = .white
    private var faceOfColor: UIColor? = .white
    
    private var offColor: UIColor? = UIColor.darkGray
    private var onColor: UIColor? = UIColor.red
    private var isOn = false

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
    
    @IBInspectable var onFaceColor: UIColor? {
        get {
            return faceOnColor
        }
        set(faceColor) {
            faceOnColor = faceColor
        }
    }
    
    @IBInspectable var offFaceColor: UIColor? {
        get {
            return faceOfColor
        }
        set(offColor) {
            faceOfColor = offColor
            circleFaceLayer?.fillColor = offColor?.cgColor
        }
    }
    
    @IBInspectable var durationAnimation: CGFloat {
        get {
            return animationDuration
        }
        set(duration) {
            animationDuration = duration
        }
    }
    
    private var circleFaceLayerInit: CAShapeLayer? {
        if circleFaceLayer == nil {
            circleFaceLayer = CAShapeLayer()
            circleFaceLayer?.frame = CGRect(x: paddingWidth, y: paddingWidth, width: circleFaceRadius * 2, height: circleFaceRadius * 2)
            let circlePath = UIBezierPath(ovalIn: circleFaceLayer!.bounds)
            circleFaceLayer?.path = circlePath.cgPath
            if let circleFaceLayer = circleFaceLayer {
                self.layer.addSublayer(circleFaceLayer)
            }
        }
        return circleFaceLayer
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
            circleFaceLayer?.position = CGPoint(x: circleFaceLayer!.position.x - moveDistance, y: circleFaceLayer!.position.y)
        } else {
            circleFaceLayer?.position = CGPoint(x: circleFaceLayer!.position.x + moveDistance, y: circleFaceLayer!.position.y)
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
        circleFaceRadius = (frame.size.height - 2 * paddingWidth) / 2
        moveDistance = frame.size.width - paddingWidth * 2 - circleFaceRadius * 2
        circleFaceLayerInit?.fillColor = UIColor.white.cgColor
        faceLayerWidth = circleFaceLayer!.frame.size.width
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
        let fromPosition  = circleFaceLayer!.position
        let toPosition = isOn ? CGPoint(x: circleFaceLayer!.position.x - moveDistance, y: circleFaceLayer!.position.y) : CGPoint(x: circleFaceLayer!.position.x + moveDistance, y: circleFaceLayer!.position.y)
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = NSValue(cgPoint: fromPosition)
        moveAnimation.toValue = NSValue(cgPoint: toPosition)
        moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        moveAnimation.duration = CFTimeInterval(animationDuration * 2 / 3)
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.fillMode = .forwards
        moveAnimation.delegate = self
        circleFaceLayer?.add(moveAnimation, forKey: "SIGlobalConstant.SIFaceMovementAnimationKey")
        self.circleFaceLayerInit?.fillColor = self.isOn ? self.faceOfColor?.cgColor : self.faceOnColor?.cgColor
        
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
        self.layer.add(colorAnimation, forKey: "SIGlobalConstant.SIBgColorAnimationKey")
    }
}
