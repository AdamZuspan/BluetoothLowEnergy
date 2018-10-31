//
//  ViewController.swift
//  BLE_Test
//
//  Created by Admin on 10/8/18.
//  Copyright © 2018 MobileAppsCompany. All rights reserved.
//

import UIKit
import CoreBluetooth

let heartRateServiceCBUUID = CBUUID(string: "0x180D")

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    var cbManager: CBCentralManager? = nil
    let peripheral: CBPeripheral? = nil
    var heartRatePeripheral: CBPeripheral!

    override func viewDidLoad() {
        super.viewDidLoad()
        cbManager = CBCentralManager(delegate: self, queue: nil)

    }
}

extension ViewController  {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOff:
            print("Central is powered off")
        case .poweredOn:
            print("Central is powered on")
            cbManager?.scanForPeripherals(withServices: [heartRateServiceCBUUID])

        case .resetting:
            print("Central is reseting")
        case .unauthorized:
            print("Central is unauthorized")
        case .unknown:
            print("Central is unknown")
        case .unsupported:
            print("Central is unsupported")
        default:
            break
        }
        
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        
        heartRatePeripheral = peripheral
        central.stopScan()
        central.connect(heartRatePeripheral, options: nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        peripheral.discoverServices(nil)
        
    }
    
}

extension ViewController {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {return}
        heartRatePeripheral.delegate = self
        heartRatePeripheral.discoverServices([heartRateServiceCBUUID])
        
        for service in services {
            print(service)
            peripheral.discoverCharacteristics([heartRateServiceCBUUID], for: service)
        }
        
    }
}



