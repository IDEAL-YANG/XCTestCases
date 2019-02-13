import UIKit

enum EngineState {
    case Start
}

class Engine {
    let state:EngineState = .Start
    var passCheck:Bool {
        return true
    }
    var wellOiled:Bool {
        return true
    }
}
class Battery {
    var hasCharge:Bool {
        return true
    }
    var connected:Bool {
        return true
    }
    var health:Double {
        return 0.85
    }
    var charge:Double {
        return 0.5
    }
}

enum AcceleratorState {
    case Pressed
    case Released
}

class Accelerator {
    let state:AcceleratorState = .Pressed
    var duration:Double = 10.0
}

class Car
{
    let engine = Engine()
    let battery = Battery()
    
    let accelerator = Accelerator()
    
    func accelerate()
    {
        guard engineStarted() && batteryHasCharge() else { return }
        
        if canAccelerate() {
            accelerateCar()
        }
    }
    
    func canAccelerate() -> Bool
    {
        switch accelerator.state {
        case .Pressed:
            return true
        case .Released:
            return false
        }
    }
    
//    func engineStarted() -> Bool
//    {
//        return engine.state == .Start
//    }
//
//    func batteryHasCharge() -> Bool
//    {
//        return battery.hasCharge
//    }
    
    func pumpFuel() -> Bool {   return true     }
    
    func accelerateCar()
    {
        while accelerator.duration > 0.0 {
            if engineStarted() && batteryHasCharge() {
                _ = pumpFuel()
                
                let distance = calculateDistanceToTravel()
                let nextPosition = calculateNextPosition(currentPosition, distance)
                moveToPosition(nextPosition)
                
                //                    let surfaceMaterial = getSurfaceMaterial()
                //                    let tireMaterial = getTireMaterial()
                //                    let friction = calculateFriction(surfaceMaterial, tireMaterial, steering)
                //                    let acceleration = accelerator.level * (weight - friction) / (weight / gravity)
                //                    let distance = currentVelocity * duration + (acceleration * duration * duration) / 2
                //                    let nextPosition = calculateNextPosition(currentPosition, distance, acceleration)
                //                    moveToPosition(nextPosition)
            }
            //                accelerator.duration -= duration
        }
    }
    
    func calculateFriction() -> Double
    {
        let surfaceMaterial = getSurfaceMaterial()
        let tireMaterial = getTireMaterial()
        let friction = calculateFriction(surfaceMaterial, tireMaterial, steering)
        return friction
    }
    
    func calculateAcceleration(friction: Double) -> Double
    {
        let acceleration = accelerator.level * (weight - friction) / (weight / gravity)
        return acceleration
    }
    
    func calculateDistance(acceleration: Double) -> Double
    {
        let distance = currentVelocity * duration + (acceleration * duration * duration) / 2
        return distance
    }
    
    func calculateDistanceToTravel() -> Double
    {
        let friction = calculateFriction()
        let acceleration = calculateAcceleration(friction)
        let distance = calculateDistance(acceleration)
        return distance
    }
    
    func calculateNextPosition(currentPosition: Point, _ distance: Double) -> Point
    {
        return Point(x: currentPosition.x + distance, y: currentPosition.y)
    }
}

/// add conditions
extension Car {
    
    func engineStarted() -> Bool
    {
        return engine.passCheck && engine.wellOiled && engine.state == .Start
    }
    
    func batteryHasCharge() -> Bool
    {
        return battery.connected && battery.health > 0.3 && battery.charge > 0.10
    }
    
}
