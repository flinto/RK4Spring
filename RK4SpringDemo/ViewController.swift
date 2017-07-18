//
//  ViewController.swift
//  RK4SpringDemo
//
//  Created by Kazuho Okui on 12/15/15.
//  Copyright © 2015 Flinto. All rights reserved.
//

import Cocoa
import RK4Spring

class CustomView : NSView {

  override var isFlipped:Bool { return true }
}


class ViewController: NSViewController {

  @objc dynamic var tension:Double  = 950
  @objc dynamic var friction:Double = 60
  @objc dynamic var velocity:Double = 0

  @IBOutlet weak var customView:CustomView!
  var shape:CAShapeLayer!

  override func viewDidAppear() {
    super.viewDidAppear()
    shape = CAShapeLayer()
    let path = CGPath(ellipseIn: CGRect(x: 0, y: 0, width: 50, height: 50), transform: nil)
    shape.path = path
    shape.fillColor = NSColor.red.cgColor
    shape.position = CGPoint(x: customView.frame.size.width/2, y: 0)
    customView.layer!.addSublayer(shape)

  }

  @IBAction func didClickButton(_ sender: AnyObject) {
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

    shape.add(anim, forKey: "position")
    shape.setValue(NSNumber(value: 100.0 as Double), forKey: "position.y")

  }

}

