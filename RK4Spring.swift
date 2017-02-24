
import Foundation

public func RK4SpringAnimation(tension:Double, friction:Double, initialVelocity:Double, delta:Double = 1/60.0) -> [Double] {

  assert(tension >= 5 && tension <= 1000, "Tension should be 5 ~ 1000")
  assert(friction >= 5 && friction <= 100, "Friction should be 5 ~ 100")

  var velocity = initialVelocity
  if velocity < -100 {
    velocity = -100
  }
  else if velocity > 100 {
    velocity = 100
  }

  var result:[Double] = []
  var value:Double = 0

  while true {

    let finished = lerpRK4Spring(value: &value, tension: tension, friction: friction, velocity: &velocity, delta: delta)
    if value.isNaN {
      break
    }
    result.append(value)
    if finished {
      break
    }
  }

  return result
}

public func lerpRK4Spring(value:inout Double, tension:Double, friction:Double, velocity:inout Double, delta:TimeInterval) -> Bool {

  if delta == 0 {
    return false
  }

  var before:SpringState = SpringState()
  var after:SpringState = SpringState()

  before.x = value - 1
  before.v = velocity
  before.tension = tension
  before.friction = friction

  after = springIntegrateState(before, speed: delta)
  value = 1 + after.x
  velocity = after.v

  value = normalizeSpringValue(value)
  velocity = normalizeSpringValue(velocity)

  let netFloat = after.x
  let net1DVelocity = after.v

  // See if we reached the end state
  let netValueIsLow = abs(netFloat) < tolerance
  let netVelocityIsLow = abs(net1DVelocity) < tolerance

  if (netValueIsLow && netVelocityIsLow) {
    return true
  }
  return false
}


//
// MARK: - Implementation details
//


private struct SpringState {
  var x:Double = 0
  var v:Double = 0
  var tension:Double = 0
  var friction:Double = 0
  init() {}
}

private struct SpringDerivative {
  var dx:Double = 0
  var dv:Double = 0
  init() {}
}

private let tolerance = 1/500.0


private func normalizeSpringValue(_ value:Double) -> Double {
  if value.isNaN {
    return 0
  }
  else if value.isInfinite {
    return (value.sign == .minus) ? -DBL_MAX : DBL_MAX
  }
  else {
    return value
  }
}

private func springAccelerationForState(_ state:SpringState) -> Double {
  return -state.tension * state.x - state.friction * state.v
}

private func springEvaluateState(_ initialState:SpringState) -> SpringDerivative {

  var output:SpringDerivative = SpringDerivative()
  output.dx = initialState.v
  output.dv = springAccelerationForState(initialState)

  return output
}

private func springEvaluateStateWithDerivative(_ initialState:SpringState, dt:Double, derivative:SpringDerivative) -> SpringDerivative {

  var state:SpringState = SpringState()
  state.x = initialState.x + derivative.dx * dt
  state.v = initialState.v + derivative.dv * dt
  state.tension = initialState.tension
  state.friction = initialState.friction

  var output:SpringDerivative = SpringDerivative()
  output.dx = state.v
  output.dv = springAccelerationForState(state)

  return output
}

private func springIntegrateState(_ state:SpringState, speed:Double) -> SpringState {
  let a = springEvaluateState(state)
  let b = springEvaluateStateWithDerivative(state, dt: speed * 0.5, derivative: a)
  let c = springEvaluateStateWithDerivative(state, dt: speed * 0.5, derivative: b)
  let d = springEvaluateStateWithDerivative(state, dt: speed,       derivative: c)

  let tx = (a.dx + 2.0 * (b.dx + c.dx) + d.dx)
  let ty = (a.dv + 2.0 * (b.dv + c.dv) + d.dv)

  let dxdt = 1.0/6.0 * tx
  let dvdt = 1.0/6.0 * ty

  var output = state

  output.x = state.x + dxdt * speed
  output.v = state.v + dvdt * speed

  return output
}
