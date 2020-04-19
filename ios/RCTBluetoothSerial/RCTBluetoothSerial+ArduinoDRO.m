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

int axisValues[6] = {9999, 9999, 9999, 9999, 9999, 9999};

@interface RCTBluetoothSerial(ArduinoDRO)
- (NSString*)readUntilDelimiter: (NSString*) delimiter;
//- (void)sendDataToSubscriber;
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
	if (axisIndex != noAxis) {
	    int value = [[message substringFromIndex:1] intValue];
		if (value != axisValues[axisIndex]) {
			axisValues[axisIndex] = value;
            return true;
		}
	}

	return false;
}

// calls the JavaScript subscriber with data if we hit the _delimiter
- (void) sendDataToSubscriber {
    NSString *message = [self readUntilDelimiter:_delimiter];

    while ([message length] > 0) {
		if ([self filterMessage:message]) {
            NSLog(@"Send message to JS: %@", message);
			[self sendEventWithName:@"data" body:@{@"data": message}];
		}

      	message = [self readUntilDelimiter:_delimiter];
    }
}

@end
