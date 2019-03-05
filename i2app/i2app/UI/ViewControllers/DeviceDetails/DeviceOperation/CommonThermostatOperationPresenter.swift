//
//  CommonThermostatOperationPresenterProtocol.swift
//  
//
//  Created by Arcus Team on 6/25/17.
//
//

import Foundation
import Cornea

protocol CommonThermostatOperationPresenterDelegate: class {
  var deviceModel: DeviceModel! { get set }

  func updateThermostat()
}

protocol CommonThermostatOperationPresenterProtocol: ThermostatOperationController,
  BatchNotificationObserver {

  var delegate: CommonThermostatOperationPresenterDelegate! { get }
  var thermostatViewModel: ThermostatControlViewModel { get set }
  var modesAvailable: [ThermostatMode] { get set }

  init(delegate: CommonThermostatOperationPresenterDelegate)

  // MARK: Extended 
  
  func fetchThermostatData()
  func update(coolSetpoint cool: Int)
  func update(heatSetpoint heat: Int)
  func update(selectedMode mode: ThermostatMode)
}

extension CommonThermostatOperationPresenterProtocol {

  func fetchThermostatData() {
    thermostatViewModel.mode = .cool
    if let mode = convertHVacMode(mode: getHVacMode(delegate.deviceModel)) {
      thermostatViewModel.mode = mode
    }
    
    // Fetch available modes
    let modes = getSupportedModes(delegate.deviceModel)
    
    // Ensure the order of modes is respected
    modesAvailable = [ThermostatMode]()
    if checkFor(mode: kEnumThermostatHvacmodeHEAT, inModes: modes) {
      modesAvailable.append(.heat)
    }
    if checkFor(mode: kEnumThermostatHvacmodeCOOL, inModes: modes) {
      modesAvailable.append(.cool)
    }
    if checkFor(mode: kEnumThermostatHvacmodeAUTO, inModes: modes) {
      modesAvailable.append(.auto)
    }
    if checkFor(mode: kEnumThermostatHvacmodeECO, inModes: modes) {
      modesAvailable.append(.eco)
    }
    if checkFor(mode: kEnumThermostatHvacmodeOFF, inModes: modes) {
      modesAvailable.append(.off)
    }
    
    // Fetch the rest of the thermostat data
    thermostatViewModel.temperatureLimitLow = celsiusToFahrenheit(getMinSetpoint(delegate.deviceModel))
    thermostatViewModel.temperatureLimitHigh = celsiusToFahrenheit(getMaxSetpoint(delegate.deviceModel))
    thermostatViewModel.currentTemperature = celsiusToFahrenheit(getCurrentTemperature(delegate.deviceModel))
    thermostatViewModel.humidity = formatHumidityPercentage(getHumidity(delegate.deviceModel))

    // Subtract 32 to create a delta in fahrenheit
    thermostatViewModel.setpointSeparation =
      celsiusToFahrenheit(getSetpointSeparation(delegate.deviceModel)) - 32

    thermostatViewModel.coolSetpoint = celsiusToFahrenheit(getCoolSetpoint(delegate.deviceModel))
    thermostatViewModel.heatSetpoint = celsiusToFahrenheit(getHeatSetpoint(delegate.deviceModel))

    delegate?.updateThermostat()
  }

  func update(coolSetpoint cool: Int) {
    DispatchQueue.global(qos: .background).async {
      _ = self.set(coolSetpoint: self.fahrenheitToCelsius(cool), onModel: self.delegate.deviceModel)
    }
  }
  
  func update(heatSetpoint heat: Int) {
    DispatchQueue.global(qos: .background).async {
      _ = self.set(heatSetpoint: self.fahrenheitToCelsius(heat), onModel: self.delegate.deviceModel)
    }
  }

  func update(selectedMode mode: ThermostatMode) {
    if thermostatViewModel.mode != mode {
      DispatchQueue.global(qos: .background).async {
        _ = self.set(mode: self.convertMode(mode: mode), onModel: self.delegate.deviceModel)
      }
    }
  }
  
  // MARK: Helpers
  
  func celsiusToFahrenheit(_ celsius: Double) -> Int {
    let newDegrees = celsius * (9/5) + 32
    return Int(round(newDegrees))
  }

  private func checkFor(mode: String, inModes modes: [Any]) -> Bool {
    for currentMode in modes {
      if let currentMode = currentMode as? String, currentMode == mode {
        return true
      }
    }

    return false
  }
  
  private func formatHumidityPercentage(_ humidity: Double?) -> Int? {
    guard let humidity = humidity else {
      return nil
    }
    
    return Int(round(humidity))
  }

  private func convertMode(mode: ThermostatMode) -> String {
    switch mode {
    case .eco:
      return kEnumThermostatHvacmodeECO
    case .auto:
      return kEnumThermostatHvacmodeAUTO
    case .heat:
      return kEnumThermostatHvacmodeHEAT
    case .cool:
      return kEnumThermostatHvacmodeCOOL
    case .off:
      return kEnumThermostatHvacmodeOFF
    }
  }

  private func convertHVacMode(mode: String?) -> ThermostatMode? {
    guard let mode = mode else {
      return nil
    }

    switch mode {
    case kEnumThermostatHvacmodeECO:
      return ThermostatMode.eco
    case kEnumThermostatHvacmodeHEAT:
      return ThermostatMode.heat
    case kEnumThermostatHvacmodeCOOL:
      return ThermostatMode.cool
    case kEnumThermostatHvacmodeAUTO:
      return ThermostatMode.auto
    default:
      return ThermostatMode.off
    }
  }

  private func fahrenheitToCelsius(_ fahrenheit: Int) -> Double {
    return Double((fahrenheit - 32) * 5) / Double(9)
  }

}
