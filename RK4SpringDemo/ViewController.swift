//
//  ViewController.swift
//  RK4SpringDemo
//
//  Created by Kazuho Okui on 12/15/15.
//  Copyright © 2015 Flinto. All rights reserved.
//

import Cocoa

class CustomView : NSView {

  override var flipped:Bool { return true }
}


class ViewController: NSViewController {

  dynamic var tension:Double  = 950
  dynamic var friction:Double = 60
  dynamic var velocity:Double = 0

  @IBOutlet weak var customView:CustomView!
  var shape:CAShapeLayer!

  override func viewDidAppear() {
    super.viewDidAppear()
    shape = CAShapeLayer()
    let path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, 50, 50), nil)
    shape.path = path
    shape.fillColor = NSColor.redColor().CGColor
    shape.position = CGPointMake(customView.frame.size.width/2, 0)
    customView.layer!.addSublayer(shape)

  }

  @IBAction func didClickButton(sender: AnyObject) {
    let values = RK4SpringAnimation(tension: tension, friction: friction, initialVelocity: velocity)
    //
    //  Because `RK4SpringAnimation` return values between 0.0 ~ 1.0, we have to multiply 100.0 to these values
    // to move CALayer 100px down
    //
    let positions = values.map {$0 * 100.0}

    // Minimal set up CAKeyFrameAnimation
    let anim = CAKeyframeAnimation(keyPath: "position.y")
    anim.values = positions

    // One sample equal to 1/60 s
    anim.duration = Double(values.count) * 1 / 60.0

    shape.addAnimation(anim, forKey: "position")
    shape.setValue(NSNumber(double: 100.0), forKey: "position.y")

  }

}

