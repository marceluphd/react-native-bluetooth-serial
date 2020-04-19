//
//  RCTBluetoothSerial.m
//  RCTBluetoothSerial
//
//  Created by Jakub Martyčák on 17.04.16.
//  Copyright © 2016 Jakub Martyčák. All rights reserved.
//

#import "RCTBluetoothSerial.h"

typedef NS_ENUM(int, AxisIndex) {
	noAxis = 0, 
	xAxis, 
	yAxis, 
	zAxis, 
	wAxis, 
	rpm
};


@interface RCTBluetoothSerial(ArduinoDRO)
int axisValues = [9999, 9999, 9999, 9999, 9999, 9999];

- (void)sendDataToSubscriber;
@end
 

@implementation RCTBluetoothSerial(AndroidDRO)

- (AxisIndex) fromChar:(char)axisSpecifier {
	switch (axisSpecifier) {
		case 'X': return xAxis;
		case 'Y': return yAxis;
		case 'Z': return zAxis;
		case 'W': return wAxis;
		case 'P': return rpm;
	}

	return noAxis;
}

- (BOOL) filterMessage:(NSString *)message {
    char axisName = [message characterAtIndex:0];
	AxisIndex axisIndex = [self fromChar:axisName];
	if (axisIndex != none) {
	    int value = [[message substringFromIndex:1] intValue];
		if (value != axisValues[axisIndex]) {
			axisValues[axisIndex];
			return truel
		}
	}

	return false;
}

// calls the JavaScript subscriber with data if we hit the _delimiter
- (void) sendDataToSubscriber {
    NSString *message = [self readUntilDelimiter:_delimiter];

    while ([message length] > 0) {
		if ([self filterMessage:message]) {
			[self sendEventWithName:@"data" body:@{@"data": message}];
		}
		
      	message = [self readUntilDelimiter:_delimiter];
    }
}

@end
