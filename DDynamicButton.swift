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
    required init?(coder aDecoder: NSCoder) {
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
    var iconScaleFactor:CGFloat{
        return self.frame.width > self.frame.height ? self.frame.height : self.frame.width
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
        let x = pointxFactor*iconScaleFactor
        let y = pointyFactor*iconScaleFactor
        return CGPointMake(x, y)
    }
    var netherPositon:CGPoint{
        let x = pointxFactor*iconScaleFactor
        let y = (CGFloat(1) - pointyFactor) * iconScaleFactor
        return CGPointMake(x, y)
    }
    var vertexPosition:CGPoint{
        let x = vertexyFactor * iconScaleFactor
        let y = iconScaleFactor/2
        return CGPointMake(x, y)
    }
    override func setup() {
        super.setup()
        drawStrokes()
    }
    func setDirection(direction:arrowDirection){
        let theValue = Double(direction.hashValue)/4
        iconLayer.transform = CATransform3DMakeRotation(CGFloat(M_PI * theValue) ,0 ,0, 1)
    }
    func drawStrokes(){
        strokeLayer.frame = iconLayer.bounds
        let thePath = UIBezierPath()
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
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let anime1 = CABasicAnimation(keyPath: "opacity")
        anime1.toValue = 1
        anime1.removedOnCompletion = false
        let anime2 = CABasicAnimation(keyPath: "transform")
        anime2.toValue = NSValue(CATransform3D: CATransform3DMakeRotation((rotateAngle * CGFloat(M_PI) / CGFloat(180)), 0, 1, 0))
        anime2.removedOnCompletion = false
        let group = CAAnimationGroup()
        group.animations = [anime1,anime2]
        strokeLayer.addAnimation(group, forKey: "Transforword")
        strokeLayer.opacity = 1
        strokeLayer.transform = CATransform3DMakeRotation((rotateAngle * CGFloat(M_PI) / CGFloat(180)), 0, 1, 0)
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        let anime1 = CABasicAnimation(keyPath: "opacity")
        anime1.toValue = 0.8
        anime1.removedOnCompletion = false
        let anime2 = CABasicAnimation(keyPath: "transform")
        anime2.toValue = NSValue(CATransform3D: CATransform3DIdentity)
        anime2.removedOnCompletion = false
        let group = CAAnimationGroup()
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
        return iconScaleFactor * (1 - strokeLengthFactor)/CGFloat(2)
    }
    var positionXRight:CGFloat{
        return iconScaleFactor * (1 + strokeLengthFactor)/CGFloat(2)
    }
    var positionY1:CGFloat{
        return iconScaleFactor * (0.5 - strokeHeightDistanceFactor)
    }
    var positionY2:CGFloat{
        return iconScaleFactor/2
    }
    var positionY3:CGFloat{
        return iconScaleFactor * (0.5 + strokeHeightDistanceFactor)
    }
    var strokeLayerUp = CAShapeLayer()
    var strokeLayerMiddle = CAShapeLayer()
    var strokeLayerDown = CAShapeLayer()
    override func setup() {
        super.setup()
        drawStrokes()
    }
    func drawStrokes(){
        let path1 = UIBezierPath()
        path1.moveToPoint(CGPointMake(positionXLeft, positionY1))
        path1.addLineToPoint(CGPointMake(positionXRight, positionY1))
        let path2 = UIBezierPath()
        path2.moveToPoint(CGPointMake(positionXLeft, positionY2))
        path2.addLineToPoint(CGPointMake(positionXRight, positionY2))
        let path3 = UIBezierPath()
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
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let positionInView = touch.locationInView(self)
        let positionOffset = (positionInView.x - iconScaleFactor/2) / (iconScaleFactor / 2)
        let animeUp = CABasicAnimation(keyPath: "transform")
        let anglePurpose = CGFloat(M_PI/8) * positionOffset
        animeUp.toValue = NSValue(CATransform3D: CATransform3DMakeRotation(anglePurpose, 0, 0, 1))
        strokeLayerUp.addAnimation(animeUp, forKey: "rotationForward")
        strokeLayerUp.transform = CATransform3DMakeRotation(anglePurpose, 0, 0, 1)
        let animeDown = CABasicAnimation(keyPath: "transform")
        animeDown.toValue = NSValue(CATransform3D: CATransform3DMakeRotation(-anglePurpose, 0, 0, 1))
        strokeLayerDown.addAnimation(animeDown, forKey: "rotationForward")
        strokeLayerDown.transform = CATransform3DMakeRotation(-anglePurpose, 0, 0, 1)
        let animeMiddle = CABasicAnimation(keyPath: "position")
        animeMiddle.toValue = NSValue(CGPoint: CGPointMake(strokeLayerUp.position.x - positionOffset * 5, strokeLayerMiddle.position.y))
        strokeLayerMiddle.addAnimation(animeMiddle, forKey: "positionForward")
        strokeLayerMiddle.position = CGPointMake(strokeLayerUp.position.x - positionOffset * 5, strokeLayerMiddle.position.y)
        let animeOpacity = CABasicAnimation(keyPath: "opacity")
        animeOpacity.toValue = 1
        let layerArray = [strokeLayerUp,strokeLayerMiddle,strokeLayerDown]
        for pathLayer in layerArray{
            pathLayer.addAnimation(animeOpacity, forKey: "OpacityForward")
            pathLayer.opacity = 1
        }
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
        let animeRotation = CABasicAnimation(keyPath: "transform")
        animeRotation.toValue = NSValue(CATransform3D: CATransform3DIdentity)
        strokeLayerUp.addAnimation(animeRotation, forKey: "rotationBackward")
        strokeLayerUp.transform = CATransform3DIdentity
        strokeLayerDown.addAnimation(animeRotation, forKey: "rotationBackward")
        strokeLayerDown.transform = CATransform3DIdentity
        let animePosition = CABasicAnimation(keyPath: "position.x")
        animePosition.toValue = strokeLayerUp.position.x
        strokeLayerMiddle.addAnimation(animePosition, forKey: "positionBackward")
        strokeLayerMiddle.position.x = strokeLayerUp.position.x
        let animeOpacity = CABasicAnimation(keyPath: "opacity")
        animeOpacity.toValue = 0.8
        let layerArray = [strokeLayerUp,strokeLayerMiddle,strokeLayerDown]
        for pathLayer in layerArray{
            pathLayer.addAnimation(animeOpacity, forKey: "OpacityBackward")
            pathLayer.opacity = 0.8
        }
    }
}
class DDynamicShareButton:DDynamicButton {
    var upperLayer = CAShapeLayer()
    var netherLayer = CAShapeLayer()
    var arrowPointOne:CGPoint{
        return CGPointMake(0.4 * iconScaleFactor, 0.25 * iconScaleFactor)
    }
    var arrowPointTwo:CGPoint{
        return CGPointMake(0.5 * iconScaleFactor, 0.175 * iconScaleFactor)
    }
    var arrowPointThree:CGPoint{
        return CGPointMake(0.6 * iconScaleFactor, 0.25 * iconScaleFactor)
    }
    var arrowPointFour:CGPoint{
        return CGPointMake(0.5 * iconScaleFactor, 0.45 * iconScaleFactor)
    }
    
    var rectPointOne:CGPoint{
        return CGPointMake(0.35 * iconScaleFactor, 0.4 * iconScaleFactor)
    }
    var rectPointTwo:CGPoint{
        return CGPointMake(0.2 * iconScaleFactor, 0.4 * iconScaleFactor)
    }
    var rectPointThree:CGPoint{
        return CGPointMake(0.2 * iconScaleFactor, 0.8 * iconScaleFactor)
    }
    var rectPointFour:CGPoint{
        return CGPointMake(0.8 * iconScaleFactor, 0.8 * iconScaleFactor)
    }
    var rectPointFive:CGPoint{
        return CGPointMake(0.8 * iconScaleFactor, 0.4 * iconScaleFactor)
    }
    var rectPointSix:CGPoint{
        return CGPointMake(0.65 * iconScaleFactor, 0.4 * iconScaleFactor)
    }
    override func setup() {
        super.setup()
        drawStrokes()
    }
    func drawStrokes(){
        upperLayer.frame = iconLayer.bounds
        upperLayer.opacity = 0.8
        netherLayer.frame = iconLayer.bounds
        netherLayer.opacity = 0.8
        let upperPath = UIBezierPath()
        upperPath.moveToPoint(arrowPointOne)
        upperPath.addLineToPoint(arrowPointTwo)
        upperPath.addLineToPoint(arrowPointThree)
        upperPath.moveToPoint(CGPointMake(arrowPointTwo.x, arrowPointTwo.y + iconScaleFactor/10))
        upperPath.addLineToPoint(arrowPointFour)
        upperLayer.lineWidth = strokelineWidth
        upperLayer.strokeColor = strokeColor
        upperLayer.lineJoin = kCALineJoinRound
        upperLayer.lineCap = kCALineCapRound
        upperLayer.path = upperPath.CGPath
        
        let netherPath = UIBezierPath()
        netherPath.moveToPoint(rectPointOne)
        netherPath.addLineToPoint(rectPointTwo)
        netherPath.addLineToPoint(rectPointThree)
        netherPath.addLineToPoint(rectPointFour)
        netherPath.addLineToPoint(rectPointFive)
        netherPath.addLineToPoint(rectPointSix)
        netherLayer.lineWidth = strokelineWidth
        netherLayer.strokeColor = strokeColor
        netherLayer.fillColor = nil
        netherLayer.lineJoin = kCALineJoinRound
        netherLayer.lineCap = kCALineCapSquare
        netherLayer.path = netherPath.CGPath
        iconLayer.addSublayer(upperLayer)
        iconLayer.addSublayer(netherLayer)
    }
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let animeOpacity = CABasicAnimation(keyPath: "opacity")
        animeOpacity.toValue = 1
        let upperAnime = CABasicAnimation(keyPath: "transform")
        let transformUpper = CATransform3DMakeRotation(CGFloat(M_PI/6), 1, 0, 0)
        upperAnime.toValue = NSValue(CATransform3D: transformUpper)
        let animePositionUpper = CABasicAnimation(keyPath: "position.y")
        animePositionUpper.toValue = netherLayer.position.y + iconScaleFactor/10
        let animeGroup1 = CAAnimationGroup()
        animeGroup1.animations = [animeOpacity,upperAnime,animePositionUpper]
        upperLayer.addAnimation(animeGroup1, forKey: "upperAnimeForward")
        upperLayer.opacity = 1
        upperLayer.position.y = netherLayer.position.y + self.bounds.width/10
        upperLayer.transform = transformUpper
        let netherAnime1 = CABasicAnimation(keyPath: "strokeEnd")
        netherAnime1.toValue = 0.95
        let netherAnime2 = CABasicAnimation(keyPath: "strokeStart")
        netherAnime2.toValue = 0.05
        let animeGroup2 = CAAnimationGroup()
        animeGroup2.animations  = [netherAnime1,netherAnime2,animeOpacity]
        netherLayer.addAnimation(animeGroup2, forKey: "netherAnimeForward")
        netherLayer.strokeStart = 0.05
        netherLayer.strokeEnd = 0.95
        netherLayer.opacity = 1
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
        let animeOpacity = CABasicAnimation(keyPath: "opacity")
        animeOpacity.toValue = 0.8
        let upperAnime = CABasicAnimation(keyPath: "transform")
        let transformUpper = CATransform3DIdentity
        upperAnime.toValue = NSValue(CATransform3D: transformUpper)
        let animePositionUpper = CABasicAnimation(keyPath: "position.y")
        animePositionUpper.toValue = netherLayer.position.y
        let animeGroup1 = CAAnimationGroup()
        animeGroup1.animations = [animeOpacity,upperAnime,animePositionUpper]
        upperLayer.addAnimation(animeGroup1, forKey: "upperAnimeBackward")
        upperLayer.opacity = 0.8
        upperLayer.position.y = netherLayer.position.y
        upperLayer.transform = transformUpper
        let netherAnime1 = CABasicAnimation(keyPath: "strokeEnd")
        netherAnime1.toValue = 1
        let netherAnime2 = CABasicAnimation(keyPath: "strokeStart")
        netherAnime2.toValue = 0
        let animeGroup2 = CAAnimationGroup()
        animeGroup2.animations  = [netherAnime1,netherAnime2,animeOpacity]
        netherLayer.addAnimation(animeGroup2, forKey: "netherAnimeBackward")
        netherLayer.strokeStart = 0
        netherLayer.strokeEnd = 1
        netherLayer.opacity = 0.8
    }
}
class DDynamicWriteButton:DDynamicButton{
    var penLayer = CAShapeLayer()
    var paperLayer = CAShapeLayer()
    override func setup() {
        super.setup()
        drawStrokes()
    }
    
    func drawStrokes(){
        penLayer.opacity = 0.8
        paperLayer.opacity = 0.8
        paperLayer.frame = iconLayer.bounds
        penLayer.frame = iconLayer.bounds
        let paperPath = UIBezierPath()
        paperPath.moveToPoint(CGPointMake(iconScaleFactor * 0.75, iconScaleFactor * 0.2))
        paperPath.addLineToPoint(CGPointMake(iconScaleFactor * 0.15, iconScaleFactor * 0.2))
        paperPath.addLineToPoint(CGPointMake(iconScaleFactor * 0.15, iconScaleFactor * 0.8))
        paperPath.addLineToPoint(CGPointMake(iconScaleFactor * 0.8, iconScaleFactor * 0.8))
        paperPath.addLineToPoint(CGPointMake(iconScaleFactor * 0.8, iconScaleFactor * 0.6))
        paperLayer.strokeColor = strokeColor
        paperLayer.lineWidth = strokelineWidth
        paperLayer.lineCap = kCALineCapRound
        paperLayer.lineJoin = kCALineJoinRound
        paperLayer.fillColor = nil
        paperLayer.path = paperPath.CGPath
        let penPath = UIBezierPath()
        penPath.moveToPoint(CGPointMake(iconScaleFactor * 0.9, iconScaleFactor * 0.25))
        penPath.addLineToPoint(CGPointMake(iconScaleFactor * 0.5, iconScaleFactor * 0.6))
        penLayer.strokeColor = strokeColor
        penLayer.lineWidth = strokelineWidth
        penLayer.lineCap = kCALineCapRound
        penLayer.lineJoin = kCALineJoinRound
        penLayer.fillColor = nil
        penLayer.path = penPath.CGPath
        iconLayer.addSublayer(paperLayer)
        iconLayer.addSublayer(penLayer)
    }
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let anime = CABasicAnimation(keyPath: "transform")
        let transformTMP = CATransform3DMakeRotation(CGFloat(-M_PI/6), 1, 0, 0)
        anime.toValue = NSValue(CATransform3D: transformTMP)
        penLayer.addAnimation(anime, forKey: "penForward")
        penLayer.transform = transformTMP
        let animeOpacity = CABasicAnimation(keyPath: "opacity")
        animeOpacity.toValue = 1
        penLayer.addAnimation(animeOpacity, forKey: "opacityOn")
        penLayer.opacity = 1
        paperLayer.addAnimation(animeOpacity, forKey: "opicityOn")
        paperLayer.opacity = 1
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
        let anime = CABasicAnimation(keyPath: "transform")
        let transformTMP = CATransform3DIdentity
        anime.toValue = NSValue(CATransform3D: transformTMP)
        penLayer.addAnimation(anime, forKey: "penBackward")
        penLayer.transform = transformTMP
        let animeOpacity = CABasicAnimation(keyPath: "opacity")
        animeOpacity.toValue = 0.8
        penLayer.addAnimation(animeOpacity, forKey: "opacityOff")
        penLayer.opacity = 0.8
        paperLayer.addAnimation(animeOpacity, forKey: "opacityOff")
        paperLayer.opacity = 0.8
    }
}
class DDynamicTextButton:DDynamicButton {
    var textLayer = CATextLayer()
    var text:String = "空缺"{
        didSet{
            textLayer.string = text
        }
    }
    override func setup() {
        super.setup()
        drawText()
    }
    func drawText(){
        textLayer.frame = iconLayer.bounds
        textLayer.opacity = 0.6
        textLayer.foregroundColor = strokeColor
        textLayer.string = text
        textLayer.fontSize = iconScaleFactor/2
        textLayer.font = CGFontCreateWithFontName("ArialUnicodeMS")
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.mainScreen().scale
        iconLayer.addSublayer(textLayer)
    }
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        textLayer.opacity = 1
        textLayer.transform = CATransform3DMakeRotation(CGFloat(M_PI/12), 1, 0, 0)
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
        textLayer.opacity = 0.6
        textLayer.transform = CATransform3DIdentity
    }
    
}






