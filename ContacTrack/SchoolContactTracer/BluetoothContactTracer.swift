//
//  BluetoothContactTracer.swift
//  ContacTrak
//
//  Created by Krish Iyengar, Sashank Balusu, Pranit Agrawal on 7/23/21.
//

import Foundation
import CoreBluetooth

// These are all of the peripherals that have been contacted with in the current device
var allPeripheralsContacted = [[String]]()

// TYhis class handles all of the contact tracing related to bluetooth
class BluetoothContactTracer: NSObject {
    
    // This is the central and peripheral managers
    var centralBluetoothManager: CBCentralManager? = nil
    var peripheralBluetoothManager: CBPeripheralManager? = nil
    
    // This will format dates
    let contactedDateFormatter = DateFormatter()
    
    // This is the delegate method that gets passed into the constructor of this class when it is initialized
    let contactTracerBluetoothDelegate: BluetoothContactTracerDelegate
    
    // This updates the contact tracer central manager every 10 seconds
    var contacTracerUpdateTimer = Timer()
    

    // Constructor method that takes an class that conforms to the BluetoothContactTracerDelegate
    init(contactTracerDelegate: BluetoothContactTracerDelegate) {
        
        // This is where the delegate gets stored in the class
        contactTracerBluetoothDelegate = contactTracerDelegate
        
        // Initialize the NSObject super class
        super.init()
        
        // Sets up the date formatted
        contactedDateFormatter.timeStyle = .medium
        contactedDateFormatter.dateStyle = .medium
        
        // Starts the central and peripheral managers
        startCentralManager()
        startPeripheralManager()
        
        // This is the update timer that starts and stops the central manager to refresh it
        contacTracerUpdateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(resetScanPeripherals), userInfo: nil, repeats: true)
    }


}

// This is an extension of the BluetoothContactTracer class that conforms to the CBCentralManagerDelegate
extension BluetoothContactTracer: CBCentralManagerDelegate {
    
    // This starts the central manager by creating an object of the CBCentralManager
    func startCentralManager() {
        centralBluetoothManager = CBCentralManager(delegate: self, queue: DispatchQueue(label: "CentralManagerDispatchQueue"))
    }
    
    // This is a method that gets called wheneve the central has its connection state updated
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        
            case .unknown:
                print("UNKNOWN CONNECTION")
                break
            case .resetting:
                print("RESETTING CONNECTION")
                break
            case .unsupported:
                print("UNSUPPORTED CONNECTION")
                break
            case .unauthorized:
                print("UNAUTHORIZED CONNECTION")
                break
            case .poweredOff:
                print("POWERED OFF CONNECTION")
                break
            case .poweredOn:
                print("POWERED ON CONNECTION")
                // When the central is powered on it starts to scan for peripherals
                centralBluetoothManager?.scanForPeripherals(withServices: nil, options: nil)
                break
            @unknown default:
                print("UNKNOWN CONNECTION")
                break
        }
    }
    // This turns off and on the central, but it only makes the central scan for peripherals when the manager's state is powered one
    @objc func resetScanPeripherals() {
        
        centralBluetoothManager?.stopScan()
        if centralBluetoothManager?.state == .poweredOn {
            centralBluetoothManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    // This is the callback method when the central discovers a new peripheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
     
        // Looks through the advertisement data to see if it is from ContacTrak
        guard let peripheralLocalName = advertisementData["kCBAdvDataLocalName"] as? String else { return }
        
        let peripheralLocalNameArray = peripheralLocalName.split(separator: ",")

        // Checking if the peripheral is of type ContacTrak
        if peripheralLocalNameArray.count >= 3 && (peripheralLocalNameArray.first) ?? "" == "ContacTrak" {
            
            // Checking if the signal is strong enough to be around 6 feet or closer
            if Int(RSSI) >= -59 {
                
                // This gets properties of the local name the peripheral is advertising
                let localNameContactedDevice = peripheralLocalNameArray[1]
                
                let contactedDeviceDate = Date()
                
                let timeContactedDevice = contactedDateFormatter.string(from: contactedDeviceDate)

                
                // Checks to make sure the peripheral is unique
                var counter = 0
                var isPeripheralConnectionUnique = true

                while counter < allPeripheralsContacted.count {
                    if localNameContactedDevice == allPeripheralsContacted[counter][0] {
                        allPeripheralsContacted[counter][1] = timeContactedDevice

                        isPeripheralConnectionUnique = false
                        
                        break
                    }
                    counter += 1
                }

                // If the peripheral is unique it gets appended to the allPeripheralsContacted contacted array
                if isPeripheralConnectionUnique {
                    allPeripheralsContacted.append([String(localNameContactedDevice), timeContactedDevice, String(peripheralLocalNameArray[2])])
                }
                
                // Then the delegate callback is called that updates the number of contacts that shows up on the main screen
                contactTracerBluetoothDelegate.updateNumberContacts()
            }
        }
    }
}

// This is an extension of the BluetoothContactTracer class that conforms to the CBPeripheralManagerDelegate
extension BluetoothContactTracer: CBPeripheralManagerDelegate {
    
    
    // This creates a new object of class CBPeripheralManager
    func startPeripheralManager() {
        
        peripheralBluetoothManager = CBPeripheralManager(delegate: self, queue: DispatchQueue(label: "PeripheralManagerDispatchQueue"))
        
    }
    
    // This is called when the state of the peripheral changes
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        
            case .unknown:
                print("UNKNOWN CONNECTION")
                break
            case .resetting:
                print("RESETTING CONNECTION")
                break
            case .unsupported:
                print("UNSUPPORTED CONNECTION")
                break
            case .unauthorized:
                print("UNAUTHORIZED CONNECTION")
                break
            case .poweredOff:
                print("POWERED OFF CONNECTION")
                break
            case .poweredOn:
                print("POWERED ON CONNECTION")
                // When the peripheral is powered on, we start advertising it, with information in its local name key
                peripheralBluetoothManager?.startAdvertising([CBAdvertisementDataLocalNameKey : "ContacTrak,\(firstNameSignUp) \(lastNameSignUp),\(emailSignUp)"])

                break
            @unknown default:
                print("UNKNOWN CONNECTION")
                break
        }
    }
    
    // This is the method to stop advertising the peripheral
    func stopPeripheralManagerAdvertising() {
        peripheralBluetoothManager?.stopAdvertising()
    }
}
// This is the protocal that has one function prototype
protocol BluetoothContactTracerDelegate: NSObject {
    // This function when implemented will set the current number of contacts to the contacts label in the main screen view controller
    func updateNumberContacts()
}
