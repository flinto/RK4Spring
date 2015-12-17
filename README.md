# RK4Spring
Implementation of [Flinto for Mac](https://www.flinto.com/mac)'s spring.

User groups / twitter:
- [Facebook Group](https://www.facebook.com/groups/flinto/)
- [@Flinto on Twitter](https://twitter.com/flinto)

# How to use

To reproduce spring values created in Flinto for Mac, use `RK4SpringAnimation` in `RK4Spring.swift`.

`public func RK4SpringAnimation(tension tension:Double, friction:Double, initialVelocity:Double, delta:Double = 1/60.0) -> [Double]`

- `tension` should be between 5.0 to 1000.0.
- `friction` should be between 5.0 to 100.0.
- `initialVelocity` should be between -100.0 to 100.0.
- `delta` is optional and only 1/60 is supported at this moment.

The return values are sample values between 0.0 to 1.0, and one sample duration is 1/60 second. Therefore, if you want to move a layer from Y=0 to Y=100, you should multiply the values by 100 and set duration to `Double(values.count) * 1 / 60.0`. The code with `CAKeyframeAnimation` would look like the following:

```
let values = RK4SpringAnimation(tension: tension, friction: friction, initialVelocity: velocity)
let positions = values.map {$0 * 100}

let anim = CAKeyframeAnimation(keyPath: "position.y")
anim.values = positions
anim.duration = Double(values.count) * 1 / 60.0

layer.addAnimation(anim, forKey: "spring")
layer.setValue(NSNumber(double: 100), forKey: "position.y")

```
