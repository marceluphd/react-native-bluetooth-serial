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
    static int axisValues[6] = {9999, 9999, 9999, 9999, 9999, 9999};
    
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

@end
