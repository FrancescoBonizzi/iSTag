//
//  DeviceOrientationHelper .swift
//  Aurora
//
//  Created by Domenico Nicoli on 22/03/2019.
//  Copyright © 2019 Domenico Nicoli. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class DeviceOrientationHelper {
    static let shared = DeviceOrientationHelper() // Singleton is recommended because an app should create only a single instance of the CMMotionManager class.
    
    private let motionManager: CMMotionManager
    private let queue: OperationQueue
    
    typealias DeviceOrientationHandler = ((_ deviceOrientation: UIDeviceOrientation) -> Void)?
    private var deviceOrientationAction: DeviceOrientationHandler?
    
    public var currentDeviceOrientation: UIDeviceOrientation = .portrait
    
    private let motionLimit: Double = 0.6 // Smallers values makes it much sensitive to detect an orientation change. [0 to 1]
    
    init() {
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.2 // Specify an update interval in seconds, personally found this value provides a good UX
        
        queue = OperationQueue()
    }
    
    public func startDeviceOrientationNotifier(with handler: DeviceOrientationHandler) {
        self.deviceOrientationAction = handler
        
        //  Using main queue is not recommended. So create new operation queue and pass it to startAccelerometerUpdatesToQueue.
        //  Dispatch U/I code to main thread using dispach_async in the handler.
        
        motionManager.startAccelerometerUpdates(to: queue) { (data, error) in
            if let accelerometerData = data {
                var newDeviceOrientation: UIDeviceOrientation?
                
                if (accelerometerData.acceleration.x >= self.motionLimit) {
                    newDeviceOrientation = .landscapeLeft
                }
                else if (accelerometerData.acceleration.x <= -self.motionLimit) {
                    newDeviceOrientation = .landscapeRight
                }
                else if (accelerometerData.acceleration.y <= -self.motionLimit) {
                    newDeviceOrientation = .portrait
                }
                else if (accelerometerData.acceleration.y >= self.motionLimit) {
                    newDeviceOrientation = .portraitUpsideDown
                }
                else {
                    return
                }
                
                // Only if a different orientation is detect, execute handler
                if newDeviceOrientation != self.currentDeviceOrientation {
                    if let orientation = newDeviceOrientation {
                        self.currentDeviceOrientation = orientation
                        if let deviceOrientationHandler = self.deviceOrientationAction {
                            DispatchQueue.main.async {
                                deviceOrientationHandler!(self.currentDeviceOrientation)
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func stopDeviceOrientationNotifier() {
        motionManager.stopAccelerometerUpdates()
    }
}
