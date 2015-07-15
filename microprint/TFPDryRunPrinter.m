//
//  TFPDryRunPrinter.m
//  MicroPrint
//
//  Created by Tomas Franzén on Wed 2015-06-24.
//

#import "TFPDryRunPrinter.h"
#import "Extras.h"


@implementation TFPDryRunPrinter

- (void)sendGCode:(TFPGCode*)GCode responseHandler:(void(^)(BOOL success, NSString *value))block {
	//TFLog(@"* Sent: %@", GCode);
	dispatch_after(dispatch_time(0, 0.02 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		block(YES, nil);
	});
}

- (TFPPrinterColor)color {
	return TFPPrinterColorOther;
}

- (NSString *)serialNumber {
	return @"TEST-00-00-00-00-123-456";
}


- (NSString *)firmwareVersion {
	return @"0000000000";
}


- (void)fetchBacklashValuesWithCompletionHandler:(void(^)(BOOL success, TFPBacklashValues values))completionHandler {
	dispatch_after(dispatch_time(0, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		completionHandler(YES, (TFPBacklashValues){0.33, 0.69});
	});
}


@end
