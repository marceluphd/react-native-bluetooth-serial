//
//  RCTBluetoothSerial.h
//  RCTBluetoothSerial
//
//  Created by Jakub Martyčák on 17.04.16.
//  Copyright © 2016 Jakub Martyčák. All rights reserved.
//

#import "RCTEventEmitter.h"

#import "BLE.h"

@interface RCTBluetoothSerial : RCTEventEmitter <BLEDelegate> {
    BLE *_bleShield;
    BOOL _subscribed;
    RCTPromiseResolveBlock _connectionResolver;
    RCTPromiseRejectBlock _connectionRejector;
    NSString* _subscribeCallbackId;
    NSString* _subscribeBytesCallbackId;
    NSString* _rssiCallbackId;
    NSMutableString *_buffer;
    NSString *_delimiter;
    
    NSInteger observerCount;
}
@end
