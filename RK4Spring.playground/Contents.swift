//: Playground - noun: a place where people can play

import Cocoa
import RK4Spring

let tension: Double = 950
let friction: Double = 50
let velocity: Double = 0

let values = RK4SpringAnimation(tension: tension, friction: friction, initialVelocity: velocity)

print(values.count)




var str = "Hello, playground"

