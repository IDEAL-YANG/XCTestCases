import UIKit

protocol Drivable
{
    func accelerate()
    func brake()
    func turnLeft()
    func turnRight()
}

protocol Maintainable
{
    func addFuel()
    func changeOil()
    func rotateTires()
}

protocol Comfortable
{
    func adjustDriverSeat()
    func turnOnAC()
    func playCD()
}

class Driving
{
    func accelerate(_ battery:Battery) {
        if battery.hasCharge() {
            moveCar()
        }
    }
    func brake() {}
    func turnLeft() {}
    func turnRight() {}
    
    private func moveCar() {}
}

class Maintenance
{
    func addFuel(_ battery:Battery) {
        battery.charge()
    }
    func changeOil() {}
    func rotateTires() {}
}

class Convenience
{
    private let cdPlayer:CDPlayer = CDPlayer()
    
    func adjustDriverSeat() {}
    func turnOnAC() {}
    func playCD(_ battery:Battery) {
        guard !battery.isLow else { return }
        if battery.hasCharge() {
            cdPlayer.play()
        }
    }
}

class Battery {
    
    var isLow:Bool = false
    
    func hasCharge() -> Bool {  return false    }
    func charge() {}
}

class CDPlayer {
    
    func play() {}
}

class Car: Drivable, Maintainable, Comfortable
{
    let driving = Driving()
    let maintenance = Maintenance()
    let convenience = Convenience()
    
    var battery = Battery()
    
    func accelerate() { driving.accelerate(battery) }
    func brake() { driving.brake() }
    func turnLeft() { driving.turnLeft() }
    func turnRight() { driving.turnRight() }
    
    func addFuel() { maintenance.addFuel(battery) }
    func changeOil() { maintenance.changeOil() }
    func rotateTires() { maintenance.rotateTires() }
    
    func adjustDriverSeat() { convenience.adjustDriverSeat() }
    func turnOnAC() { convenience.turnOnAC() }
    func playCD() { convenience.playCD(battery) }
}


