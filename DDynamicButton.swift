//
//  DDynamicButton.swift
//  DDynamicButtonDemo
//
//  Created by 端 闻 on 21/11/14.
//  Copyright (c) 2014年 monk-studio. All rights reserved.
//

import UIKit


class DDynamicButton: UIControl {
    var strokeColor:CGColorRef = UIColor.blackColor().CGColor{
        didSet{
            setup()
        }
    }
    var strokelineWidth:CGFloat{
        if iconLayer.bounds.width > iconLayer.bounds.height{
            return iconLayer.bounds.height/10
        }else{
            return iconLayer.bounds.width/10
        }
    }
    var iconLayer = CAShapeLayer()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    func setup(){
        iconLayer.frame = layer.bounds
        self.layer.addSublayer(iconLayer)
    }
}

enum arrowDirection:Int{
    case left = 0
    case leftUp,up,rightUp,right,rightDown,down,leftDown
}
class DDynamicArrowButton:DDynamicButton{
    let pointxFactor:CGFloat = 0.67
    let pointyFactor:CGFloat = 0.16
    let vertexyFactor:CGFloat = 0.22
    var rotateAngle:CGFloat = 45
    var direction:arrowDirection = arrowDirection.left{
        didSet{
            setDirection(direction)
        }
    }
    var strokeLayer = CAShapeLayer()
    var upperPosition:CGPoint{
        var x = pointxFactor*self.frame.width
        var y = pointyFactor*self.frame.height
        return CGPointMake(x, y)
    }
    var netherPositon:CGPoint{
        var x = pointxFactor*self.frame.width
        var y = (CGFloat(1) - pointyFactor) * self.frame.height
        return CGPointMake(x, y)
    }
    var vertexPosition:CGPoint{
        var x = vertexyFactor * self.frame.width
        var y = self.frame.height/2
        return CGPointMake(x, y)
    }
    override func setup() {
        super.setup()
        drawStrokes()
    }
    func setDirection(direction:arrowDirection){
        var theValue = Double(direction.hashValue)/4
        println(theValue)
        iconLayer.transform = CATransform3DMakeRotation(CGFloat(M_PI * theValue) ,0 ,0, 1)
    }
    func drawStrokes(){
        strokeLayer.frame = iconLayer.bounds
        var thePath = UIBezierPath()
        thePath.moveToPoint(upperPosition)
        thePath.addLineToPoint(vertexPosition)
        thePath.addLineToPoint(netherPositon)
        strokeLayer.path = thePath.CGPath
        strokeLayer.strokeColor = strokeColor
        strokeLayer.fillColor = nil
        strokeLayer.lineWidth = strokelineWidth
        strokeLayer.lineCap = kCALineCapRound
        strokeLayer.lineJoin = kCALineJoinRound
        strokeLayer.opacity = 0.8
        iconLayer.addSublayer(strokeLayer)
    }
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        var anime1 = CABasicAnimation(keyPath: "opacity")
        anime1.toValue = 1
        anime1.removedOnCompletion = false
        var anime2 = CABasicAnimation(keyPath: "transform")
        anime2.toValue = NSValue(CATransform3D: CATransform3DMakeRotation((rotateAngle * CGFloat(M_PI) / CGFloat(180)), 0, 1, 0))
        anime2.removedOnCompletion = false
        var group = CAAnimationGroup()
        group.animations = [anime1,anime2]
        strokeLayer.addAnimation(group, forKey: "Transforword")
        strokeLayer.opacity = 1
        strokeLayer.transform = CATransform3DMakeRotation((rotateAngle * CGFloat(M_PI) / CGFloat(180)), 0, 1, 0)
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        var anime1 = CABasicAnimation(keyPath: "opacity")
        anime1.toValue = 0.8
        anime1.removedOnCompletion = false
        var anime2 = CABasicAnimation(keyPath: "transform")
        anime2.toValue = NSValue(CATransform3D: CATransform3DIdentity)
        anime2.removedOnCompletion = false
        var group = CAAnimationGroup()
        group.animations = [anime1,anime2]
        strokeLayer.addAnimation(group, forKey: "TranBackword")
        strokeLayer.opacity = 0.8
        strokeLayer.transform = CATransform3DIdentity
        super.endTrackingWithTouch(touch, withEvent: event)
    }
}
class DDynamicMenuButton:DDynamicButton {
    let strokeHeightDistanceFactor:CGFloat = 0.28
    let strokeLengthFactor:CGFloat = 0.76
    var positionXLeft:CGFloat{
        return self.frame.width * (1 - strokeLengthFactor)/CGFloat(2)
    }
    var positionXRight:CGFloat{
        return self.frame.width * (1 + strokeLengthFactor)/CGFloat(2)
    }
    var positionY1:CGFloat{
        return self.frame.height * (0.5 - strokeHeightDistanceFactor)
    }
    var positionY2:CGFloat{
        return self.frame.height/2
    }
    var positionY3:CGFloat{
        return self.frame.height * (0.5 + strokeHeightDistanceFactor)
    }
    var strokeLayerUp = CAShapeLayer()
    var strokeLayerMiddle = CAShapeLayer()
    var strokeLayerDown = CAShapeLayer()
    override func setup() {
        super.setup()
        drawStrokes()
    }
    func drawStrokes(){
        var path1 = UIBezierPath()
        path1.moveToPoint(CGPointMake(positionXLeft, positionY1))
        path1.addLineToPoint(CGPointMake(positionXRight, positionY1))
        var path2 = UIBezierPath()
        path2.moveToPoint(CGPointMake(positionXLeft, positionY2))
        path2.addLineToPoint(CGPointMake(positionXRight, positionY2))
        var path3 = UIBezierPath()
        path3.moveToPoint(CGPointMake(positionXLeft, positionY3))
        path3.addLineToPoint(CGPointMake(positionXRight, positionY3))
        
        strokeLayerUp.path = path1.CGPath
        strokeLayerMiddle.path = path2.CGPath
        strokeLayerDown.path = path3.CGPath
        let layerArray = [strokeLayerUp,strokeLayerMiddle,strokeLayerDown]
        for pathLayer in layerArray{
            pathLayer.frame = iconLayer.bounds
            pathLayer.lineWidth = strokelineWidth
            pathLayer.lineCap = kCALineCapRound
            pathLayer.strokeColor = strokeColor
            pathLayer.opacity = 0.8
            iconLayer.addSublayer(pathLayer)
        }
    }
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        var positionInView = touch.locationInView(self)
        var positionOffset = (positionInView.x - self.frame.width/2) / (self.frame.width / 2)
        var animeUp = CABasicAnimation(keyPath: "transform")
        var anglePurpose = CGFloat(M_PI/8) * positionOffset
        animeUp.toValue = NSValue(CATransform3D: CATransform3DMakeRotation(anglePurpose, 0, 0, 1))
        strokeLayerUp.addAnimation(animeUp, forKey: "rotationForward")
        strokeLayerUp.transform = CATransform3DMakeRotation(anglePurpose, 0, 0, 1)
        var animeDown = CABasicAnimation(keyPath: "transform")
        animeDown.toValue = NSValue(CATransform3D: CATransform3DMakeRotation(-anglePurpose, 0, 0, 1))
        strokeLayerDown.addAnimation(animeDown, forKey: "rotationForward")
        strokeLayerDown.transform = CATransform3DMakeRotation(-anglePurpose, 0, 0, 1)
        var animeMiddle = CABasicAnimation(keyPath: "position")
        animeMiddle.toValue = NSValue(CGPoint: CGPointMake(strokeLayerUp.position.x - positionOffset * 5, strokeLayerMiddle.position.y))
        strokeLayerMiddle.addAnimation(animeMiddle, forKey: "positionForward")
        strokeLayerMiddle.position = CGPointMake(strokeLayerUp.position.x - positionOffset * 5, strokeLayerMiddle.position.y)
        var animeOpacity = CABasicAnimation(keyPath: "opacity")
        animeOpacity.toValue = 1
        let layerArray = [strokeLayerUp,strokeLayerMiddle,strokeLayerDown]
        for pathLayer in layerArray{
            pathLayer.addAnimation(animeOpacity, forKey: "OpacityForward")
            pathLayer.opacity = 1
        }
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        super.endTrackingWithTouch(touch, withEvent: event)
        var animeRotation = CABasicAnimation(keyPath: "transform")
        animeRotation.toValue = NSValue(CATransform3D: CATransform3DIdentity)
        strokeLayerUp.addAnimation(animeRotation, forKey: "rotationBackward")
        strokeLayerUp.transform = CATransform3DIdentity
        strokeLayerDown.addAnimation(animeRotation, forKey: "rotationBackward")
        strokeLayerDown.transform = CATransform3DIdentity
        var animePosition = CABasicAnimation(keyPath: "position.x")
        animePosition.toValue = strokeLayerUp.position.x
        strokeLayerMiddle.addAnimation(animePosition, forKey: "positionBackward")
        strokeLayerMiddle.position.x = strokeLayerUp.position.x
        var animeOpacity = CABasicAnimation(keyPath: "opacity")
        animeOpacity.toValue = 0.8
        let layerArray = [strokeLayerUp,strokeLayerMiddle,strokeLayerDown]
        for pathLayer in layerArray{
            pathLayer.addAnimation(animeOpacity, forKey: "OpacityBackward")
            pathLayer.opacity = 0.8
        }
    }
}




