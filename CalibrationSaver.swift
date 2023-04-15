//
//  CalibrationSaver.swift
//  PASCAL
//
//  Created by Keshav Infotech on 25/03/23.
//

import Foundation
import CoreBluetooth



class CalibrationSaver: NSObject {
    
    static let shared = CalibrationSaver()
    typealias SaveCalibrationDidFinish = () -> Void
    typealias StopCallback = () -> Void
    typealias CallbackForLog = (String) -> Void
    var saveCalibrationDidFinish: SaveCalibrationDidFinish?
    var stopCallback: StopCallback?
    var callbackForLog: CallbackForLog?
    var stopFlag = false
    var data = Data()
    var buffer = Data()
    var calibrationData = CalibrationData()
    var deviceName: String? = "Reacxle Device"
    
    private override init() {
        super.init()
    }
    
    public func startSavingCalibrationData(deviceName: String) {
        callbackForLog?("#startSavingCalibrationData")
#if targetEnvironment(simulator)
        calibrationData.spifOwner = "spifOwner"
        calibrationData.spifVIN = "spifVIN"
        calibrationData.spifAgent = "spifAgent"
        calibrationData.spifDesc = "spifDesc"
        calibrationData.zeroA = "zeroA"
        calibrationData.zeroB = "zeroB"
        calibrationData.zeroC = "zeroC"
        calibrationData.factorADot1 = "ADot1"
        calibrationData.pointADot1 = "ADot1"
        calibrationData.factorADot2 = "ADot2"
        calibrationData.pointADot2 = "ADot2"
        calibrationData.factorADot3 = "ADot3"
        calibrationData.pointADot3 = "ADot3"
        calibrationData.factorBDot1 = "BDot1"
        calibrationData.pointBDot1 = "BDot1"
        calibrationData.factorCDot1 = "CDot1"
        calibrationData.pointCDot1 = "CDot1"
        calibrationData.factorBDot2 = "BDot2"
        calibrationData.pointBDot2 = "BDot2"
        calibrationData.factorCDot2 = "CDot2"
        calibrationData.pointCDot2 = "CDot2"
        calibrationData.factorBDot3 = "BDot3"
        calibrationData.pointBDot3 = "BDot3"
        calibrationData.factorCDot3 = "CDot3"
        calibrationData.pointCDot3 = "CDot3"
        calibrationData.emptyA = "emptyA"
        calibrationData.emptyB = "emptyB"
        calibrationData.emptyC = "emptyC"
        calibrationData.fullA = "fullA"
        calibrationData.fullB = "fullB"
        calibrationData.fullC = "fullC"
        calibrationData.cLoadA = "cLoadA"
        calibrationData.cLoadB = "cLoadB"
        calibrationData.cLoadC = "cLoadC"
        calibrationData.unitType = "KG"
        calibrationData.deviceName = "Reacxle Device"
        calibrationData.deviceAddress = "deviceAddress"
        calibrationData.createdAt = Int(Date().timeIntervalSince1970)
        calibrationData.frame = "frame"
        calibrationData.lat = "lat"
        calibrationData.lng = "lng"
        calibrationData.address = "address"
        
        DBManager.sharedDbManager().saveCalibrationData(calibrationData: calibrationData)
        saveCalibrationDidFinish?()
        stopFlag = false
#else
        discoveredPeripheral?.delegate = self
        manager?.delegate = self
        self.deviceName = deviceName
        callbackForLog?("#\(deviceName)")
        sendCommand(command: .readSpifOwner)
#endif

    }
    
    private func sendCommand(command: Commands, confirmPassword:String = "", writingValue: String = "") {
        
        if stopFlag {
            stopCallback?()
            stopFlag = false
            return
        }
        
        var sendingCommand = ""
        
        switch command {
        case .readSpifOwner:
            sendingCommand = SharedCommands.shared.readSpifOwner.getCommand()
            break
        case .readSPIFVin:
            sendingCommand = SharedCommands.shared.readSPIFVin.getCommand()
            break
        case .readSPIFAgentCertificate:
            sendingCommand = SharedCommands.shared.readSPIFAgentCertificate.getCommand()
            break
        case .readSPIFDescription:
            sendingCommand = SharedCommands.shared.readSPIFDescription.getCommand()
            break
        case .emptyA:
            sendingCommand = SharedCommands.shared.readEmptyValueACommand.getCommand()
            break
        case .emptyB:
            sendingCommand = SharedCommands.shared.readEmptyValueBCommand.getCommand()
            break
        case .emptyC:
            sendingCommand = SharedCommands.shared.readEmptyValueCCommand.getCommand()
            break
        case .readZeroA:
            sendingCommand = SharedCommands.shared.readZeroA.getCommand()
            break
        case .readZeroB:
            sendingCommand = SharedCommands.shared.readZeroB.getCommand()
            break
        case .readZeroC:
            sendingCommand = SharedCommands.shared.readZeroC.getCommand()
            break
        case .readFactorADot1:
            sendingCommand = SharedCommands.shared.readFactorADot1.getCommand()
            break
        case .readPointADot1:
            sendingCommand = SharedCommands.shared.readPointADot1.getCommand()
            break
        case .readFactorADot2:
            sendingCommand = SharedCommands.shared.readFactorADot2.getCommand()
            break
        case .readPointADot2:
            sendingCommand = SharedCommands.shared.readPointADot2.getCommand()
            break
        case .readFactorADot3:
            sendingCommand = SharedCommands.shared.readFactorADot3.getCommand()
            break
        case .readPointADot3:
            sendingCommand = SharedCommands.shared.readPointADot3.getCommand()
            break
        case .readFactorBDot1:
            sendingCommand = SharedCommands.shared.readFactorBDot1.getCommand()
            break
        case .readPointBDot1:
            sendingCommand = SharedCommands.shared.readPointBDot1.getCommand()
            break
        case .readFactorBDot2:
            sendingCommand = SharedCommands.shared.readFactorBDot2.getCommand()
            break
        case .readPointBDot2:
            sendingCommand = SharedCommands.shared.readPointBDot2.getCommand()
            break
        case .readFactorBDot3:
            sendingCommand = SharedCommands.shared.readFactorBDot3.getCommand()
            break
        case .readPointBDot3:
            sendingCommand = SharedCommands.shared.readPointBDot3.getCommand()
            break
        case .readFactorCDot1:
            sendingCommand = SharedCommands.shared.readFactorCDot1.getCommand()
            break
        case .readPointCDot1:
            sendingCommand = SharedCommands.shared.readPointCDot1.getCommand()
            break
        case .readFactorCDot2:
            sendingCommand = SharedCommands.shared.readFactorCDot2.getCommand()
            break
        case .readPointCDot2:
            sendingCommand = SharedCommands.shared.readPointCDot2.getCommand()
            break
        case .readFactorCDot3:
            sendingCommand = SharedCommands.shared.readFactorCDot3.getCommand()
            break
        case .readPointCDot3:
            sendingCommand = SharedCommands.shared.readPointCDot3.getCommand()
            break
        case .grossWeightA:
            sendingCommand = SharedCommands.shared.readGrossWeightACommand.getCommand()
            break
        case .grossWeightB:
            sendingCommand = SharedCommands.shared.readGrossWeightBCommand.getCommand()
            break
        case .grossWeightC:
            sendingCommand = SharedCommands.shared.readGrossWeightCCommand.getCommand()
            break
        case .certifiedLoadA:
            sendingCommand = SharedCommands.shared.readCertifiedLoadACommand.getCommand()
            break
        case .certifiedLoadB:
            sendingCommand = SharedCommands.shared.readCertifiedLoadBCommand.getCommand()
            break
        case .certifiedLoadC:
            sendingCommand = SharedCommands.shared.readCertifiedLoadCCommand.getCommand()
            break
        default:
            break
        }
        
        print(sendingCommand)
        self.data = Data(sendingCommand.utf8)
        self.writeData()
    }
    
    private func removeCommand(command: String, fromBuffer: String) {
        let remainingString = fromBuffer.replacingOccurrences(of: command, with: "")
        buffer.removeAll()
        buffer.append(Data(remainingString.utf8))
    }
    
    private func writeData() {
        
        guard let discoveredPeripheral = discoveredPeripheral else { return }
        
        print("WriteData() --> Command Sent")
        let str = String(decoding: data, as: UTF8.self)
        callbackForLog?("#Command Sent --> \(str)")
        
        var writeCount = 0
        let dataLen = data.count
        
        if dataLen > 20 {
            let range: Range = writeCount..<20
            while (writeCount < dataLen && dataLen - writeCount > 20) {
                let stringFromData = String(data: data.subdata(in: range), encoding: .utf8)
                print("Writing \(String(describing: stringFromData!)) bytes: \(stringFromData?.count ?? 0)")
                discoveredPeripheral.writeValue(data.subdata(in: range), for: writeCharacteristic!, type: .withoutResponse)
                sleep(UInt32(0.005))
                data.removeSubrange(range)
                writeCount += 20
            }
        }
        
        let rangeLatter = 0..<data.count
        
        if (writeCount < dataLen) {
            discoveredPeripheral.writeValue(data.subdata(in: rangeLatter), for: writeCharacteristic!, type: .withoutResponse)
        }
        
        data.removeAll()
    }
    
    private func insertData() {
        
        calibrationData.unitType = getUnit()
        calibrationData.deviceName = self.deviceName
        calibrationData.deviceAddress = ""
        calibrationData.createdAt = Int(Date().timeIntervalSince1970)
        calibrationData.frame = ""
        calibrationData.lat = ""
        calibrationData.lng = ""
        calibrationData.address = ""
        
        DBManager.sharedDbManager().saveCalibrationData(calibrationData: calibrationData)
        saveCalibrationDidFinish?()
        stopFlag = false
    }
}

extension CalibrationSaver: CBPeripheralDelegate, CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if stopFlag {
            stopCallback?()
            stopFlag = false
            return
        }
        
        if let error = error {
            print("Error discovering characteristics: %s", error.localizedDescription)
            return
        }
        
        guard let characteristicData = characteristic.value else { return }
        buffer.append(characteristicData)
        guard let stringFromData = String(data: buffer, encoding: .utf8) else { return }
        
        print("Received \(buffer.count) bytes: \(stringFromData)")
        callbackForLog?("#Received \(buffer.count) bytes: \(stringFromData)")

        if SharedCommands.shared.readSpifOwner.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readSpifOwner.getOutput(from: stringFromData).0 == "ERR" {
                calibrationData.spifOwner = "n/a"
            } else {
                calibrationData.spifOwner = SharedCommands.shared.readSpifOwner.getOutput(from: stringFromData).0
            }
            removeCommand(command: SharedCommands.shared.readSpifOwner.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readSPIFVin)
        } else if SharedCommands.shared.readSPIFVin.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readSPIFVin.getOutput(from: stringFromData).0 == "ERR" {
                calibrationData.spifVIN = "n/a"
            } else {
                calibrationData.spifVIN = SharedCommands.shared.readSPIFVin.getOutput(from: stringFromData).0
            }
            removeCommand(command: SharedCommands.shared.readSPIFVin.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readSPIFAgentCertificate)
        } else if SharedCommands.shared.readSPIFAgentCertificate.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readSPIFAgentCertificate.getOutput(from: stringFromData).0 == "ERR" {
                calibrationData.spifAgent = "n/a"
            } else {
                calibrationData.spifAgent = SharedCommands.shared.readSPIFAgentCertificate.getOutput(from: stringFromData).0
            }
            removeCommand(command: SharedCommands.shared.readSPIFAgentCertificate.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readSPIFDescription)
        } else if SharedCommands.shared.readSPIFDescription.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readSPIFDescription.getOutput(from: stringFromData).0 == "ERR" {
                calibrationData.spifDesc = "n/a"
            } else {
                calibrationData.spifDesc = SharedCommands.shared.readSPIFDescription.getOutput(from: stringFromData).0
            }
            removeCommand(command: SharedCommands.shared.readSPIFDescription.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .emptyA)
        } else if SharedCommands.shared.readEmptyValueACommand.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readEmptyValueACommand.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readEmptyValueACommand.getOutput(from: stringFromData).0 != "ERR"{
                calibrationData.emptyA = SharedCommands.shared.readEmptyValueACommand.getOutput(from: stringFromData).0
            } else {
                calibrationData.emptyA = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readEmptyValueACommand.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .emptyB)
        } else if SharedCommands.shared.readEmptyValueBCommand.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readEmptyValueBCommand.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readEmptyValueBCommand.getOutput(from: stringFromData).0 != "ERR"{
                calibrationData.emptyB = SharedCommands.shared.readEmptyValueBCommand.getOutput(from: stringFromData).0
            } else {
                calibrationData.emptyB = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readEmptyValueBCommand.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .emptyC)
        } else if SharedCommands.shared.readEmptyValueCCommand.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readEmptyValueCCommand.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readEmptyValueCCommand.getOutput(from: stringFromData).0 != "ERR" {
                calibrationData.emptyC = SharedCommands.shared.readEmptyValueCCommand.getOutput(from: stringFromData).0
            } else {
                calibrationData.emptyC = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readEmptyValueCCommand.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readZeroA)
        } else if SharedCommands.shared.readZeroA.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readZeroA.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readZeroA.getOutput(from: stringFromData).0 != "ERR" {
                calibrationData.zeroA = SharedCommands.shared.readZeroA.getOutput(from: stringFromData).0
            } else {
                calibrationData.zeroA = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readZeroA.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readZeroB)
        } else if SharedCommands.shared.readZeroB.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readZeroB.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readZeroB.getOutput(from: stringFromData).0 != "ERR" {
                calibrationData.zeroB = SharedCommands.shared.readZeroB.getOutput(from: stringFromData).0
            } else {
                calibrationData.zeroB = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readZeroB.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readZeroC)
        } else if SharedCommands.shared.readZeroC.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readZeroC.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readZeroC.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readZeroC.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.zeroC = SharedCommands.shared.readZeroC.getOutput(from: stringFromData).0
            } else {
                calibrationData.zeroC = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readZeroC.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readFactorADot1)
        } else if SharedCommands.shared.readFactorADot1.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readFactorADot1.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readFactorADot1.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readFactorADot1.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.factorADot1 = SharedCommands.shared.readFactorADot1.getOutput(from: stringFromData).0
            } else {
                calibrationData.factorADot1 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readFactorADot1.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readPointADot1)
        } else if SharedCommands.shared.readPointADot1.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readPointADot1.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readPointADot1.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readPointADot1.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.pointADot1 = SharedCommands.shared.readPointADot1.getOutput(from: stringFromData).0
            } else {
                calibrationData.pointADot1 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readPointADot1.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readFactorADot2)
        } else if SharedCommands.shared.readFactorADot2.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readFactorADot2.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readFactorADot2.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readFactorADot2.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.factorADot2 = SharedCommands.shared.readFactorADot2.getOutput(from: stringFromData).0
            } else {
                calibrationData.factorADot2 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readFactorADot2.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readPointADot2)
        } else if SharedCommands.shared.readPointADot2.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readPointADot2.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readPointADot2.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readPointADot2.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.pointADot2 = SharedCommands.shared.readPointADot2.getOutput(from: stringFromData).0
            } else {
                calibrationData.pointADot2 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readPointADot2.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readFactorADot3)
        } else if SharedCommands.shared.readFactorADot3.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readFactorADot3.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readFactorADot3.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readFactorADot3.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.factorADot3 = SharedCommands.shared.readFactorADot3.getOutput(from: stringFromData).0
            } else {
                calibrationData.factorADot3 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readFactorADot3.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readPointADot3)
        } else if SharedCommands.shared.readPointADot3.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readPointADot3.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readPointADot3.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readPointADot3.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.pointADot3 = SharedCommands.shared.readPointADot3.getOutput(from: stringFromData).0
            } else {
                calibrationData.pointADot3 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readPointADot3.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readFactorBDot1)
        } else if SharedCommands.shared.readFactorBDot1.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readFactorBDot1.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readFactorBDot1.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readFactorBDot1.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.factorBDot1 = SharedCommands.shared.readFactorBDot1.getOutput(from: stringFromData).0
            } else {
                calibrationData.factorBDot1 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readFactorBDot1.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readPointBDot1)
        } else if SharedCommands.shared.readPointBDot1.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readPointBDot1.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readPointBDot1.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readPointBDot1.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.pointBDot1 = SharedCommands.shared.readPointBDot1.getOutput(from: stringFromData).0
            } else {
                calibrationData.pointBDot1 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readPointBDot1.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readFactorBDot2)
        } else if SharedCommands.shared.readFactorBDot2.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readFactorBDot2.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readFactorBDot2.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readFactorBDot2.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.factorBDot2 = SharedCommands.shared.readFactorBDot2.getOutput(from: stringFromData).0
            } else {
                calibrationData.factorBDot2 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readFactorBDot2.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readPointBDot2)
        } else if SharedCommands.shared.readPointBDot2.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readPointBDot2.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readPointBDot2.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readPointBDot2.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.pointBDot2 = SharedCommands.shared.readPointBDot2.getOutput(from: stringFromData).0
            } else {
                calibrationData.pointBDot2 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readPointBDot2.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readFactorBDot3)
        } else if SharedCommands.shared.readFactorBDot3.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readFactorBDot3.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readFactorBDot3.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readFactorBDot3.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.factorBDot3 = SharedCommands.shared.readFactorBDot3.getOutput(from: stringFromData).0
            } else {
                calibrationData.factorBDot3 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readFactorBDot3.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readPointBDot3)
        } else if SharedCommands.shared.readPointBDot3.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readPointBDot3.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readPointBDot3.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readPointBDot3.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.pointBDot3 = SharedCommands.shared.readPointBDot3.getOutput(from: stringFromData).0
            } else {
                calibrationData.pointBDot3 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readPointBDot3.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readFactorCDot1)
        } else if SharedCommands.shared.readFactorCDot1.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readFactorCDot1.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readFactorCDot1.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readFactorCDot1.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.factorCDot1 = SharedCommands.shared.readFactorCDot1.getOutput(from: stringFromData).0
            } else {
                calibrationData.factorCDot1 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readFactorCDot1.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readPointCDot1)
        } else if SharedCommands.shared.readPointCDot1.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readPointCDot1.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readPointCDot1.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readPointCDot1.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.pointCDot1 = SharedCommands.shared.readPointCDot1.getOutput(from: stringFromData).0
            } else {
                calibrationData.pointCDot1 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readPointCDot1.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readFactorCDot2)
        } else if SharedCommands.shared.readFactorCDot2.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readFactorCDot2.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readFactorCDot2.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readFactorCDot2.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.factorCDot2 = SharedCommands.shared.readFactorCDot2.getOutput(from: stringFromData).0
            } else {
                calibrationData.factorCDot2 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readFactorCDot2.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readPointCDot2)
        } else if SharedCommands.shared.readPointCDot2.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readPointCDot2.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readPointCDot2.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readPointCDot2.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.pointCDot2 = SharedCommands.shared.readPointCDot2.getOutput(from: stringFromData).0
            } else {
                calibrationData.pointCDot2 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readPointCDot2.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readFactorCDot3)
        } else if SharedCommands.shared.readFactorCDot3.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readFactorCDot3.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readFactorCDot3.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readFactorCDot3.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.factorCDot3 = SharedCommands.shared.readFactorCDot3.getOutput(from: stringFromData).0
            } else {
                calibrationData.factorCDot3 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readFactorCDot3.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .readPointCDot3)
        } else if SharedCommands.shared.readPointCDot3.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readPointCDot3.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readPointCDot3.getOutput(from: stringFromData).0 != "ERR" && SharedCommands.shared.readPointCDot3.getOutput(from: stringFromData).0 != "NA" {
                calibrationData.pointCDot3 = SharedCommands.shared.readPointCDot3.getOutput(from: stringFromData).0
            } else {
                calibrationData.pointCDot3 = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readPointCDot3.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .grossWeightA)
        } else if SharedCommands.shared.readGrossWeightACommand.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readGrossWeightACommand.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readGrossWeightACommand.getOutput(from: stringFromData).0 != "ERR" {
                calibrationData.fullA = SharedCommands.shared.readGrossWeightACommand.getOutput(from: stringFromData).0
            } else {
                calibrationData.fullA = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readGrossWeightACommand.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .grossWeightB)
        } else if SharedCommands.shared.readGrossWeightBCommand.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readGrossWeightBCommand.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readGrossWeightBCommand.getOutput(from: stringFromData).0 != "ERR" {
                calibrationData.fullB = SharedCommands.shared.readGrossWeightBCommand.getOutput(from: stringFromData).0
            } else {
                calibrationData.fullB = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readGrossWeightBCommand.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .grossWeightC)
        } else if SharedCommands.shared.readGrossWeightCCommand.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readGrossWeightCCommand.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readGrossWeightCCommand.getOutput(from: stringFromData).0 != "ERR" {
                calibrationData.fullC = SharedCommands.shared.readGrossWeightCCommand.getOutput(from: stringFromData).0
            } else {
                calibrationData.fullC = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readGrossWeightCCommand.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .certifiedLoadA)
        } else if SharedCommands.shared.readCertifiedLoadACommand.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readCertifiedLoadACommand.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readCertifiedLoadACommand.getOutput(from: stringFromData).0 != "ERR" {
                calibrationData.cLoadA = SharedCommands.shared.readCertifiedLoadACommand.getOutput(from: stringFromData).0
            } else {
                calibrationData.cLoadA = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readCertifiedLoadACommand.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .certifiedLoadB)
        } else if SharedCommands.shared.readCertifiedLoadBCommand.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readCertifiedLoadBCommand.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readCertifiedLoadBCommand.getOutput(from: stringFromData).0 != "ERR" {
                calibrationData.cLoadB = SharedCommands.shared.readCertifiedLoadBCommand.getOutput(from: stringFromData).0
            } else {
                calibrationData.cLoadB = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readCertifiedLoadBCommand.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            sendCommand(command: .certifiedLoadC)
        } else if SharedCommands.shared.readCertifiedLoadCCommand.getOutput(from: stringFromData).0 != "" {
            if SharedCommands.shared.readCertifiedLoadCCommand.getOutput(from: stringFromData).0 != "OK" && SharedCommands.shared.readCertifiedLoadCCommand.getOutput(from: stringFromData).0 != "ERR" {
                calibrationData.cLoadC = SharedCommands.shared.readCertifiedLoadCCommand.getOutput(from: stringFromData).0
            } else {
                calibrationData.cLoadC = "n/a"
            }
            removeCommand(command: SharedCommands.shared.readCertifiedLoadCCommand.getOutput(from: stringFromData).1, fromBuffer: stringFromData)
            insertData()
        }
    }
}

