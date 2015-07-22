//
//  TFPDryRunPrinter.m
//  MicroPrint
//
//  Created by Tomas Franzén on Wed 2015-06-24.
//

#import "TFPDryRunPrinter.h"
#import "Extras.h"


@interface TFPPrinter (Private)
@property (readwrite) BOOL pendingConnection;
@property (readwrite) NSString *serialNumber;
@end


@interface TFPDryRunPrinter ()
@property TFP3DVector *simulatedPosition;
@property BOOL relativeMode;
@end



@implementation TFPDryRunPrinter


- (instancetype)init {
	if(!(self = [super init])) return nil;
	
	self.simulatedPosition = [TFP3DVector zeroVector];
	
	return self;
}


- (void)sendGCode:(TFPGCode*)code responseHandler:(void(^)(BOOL success, NSString *value))block {
	NSInteger G = [code valueForField:'G' fallback:-1];
	TFLog(@"* Sent: %@", code);
	NSTimeInterval duration = 0.02;
	
	if(G == 0 || G == 1) {
		TFP3DVector *movement = [code movementVector];
		
		if(self.relativeMode) {
			movement = [TFP3DVector vectorWithX:@(self.simulatedPosition.x.doubleValue + movement.x.doubleValue)
											  Y:@(self.simulatedPosition.y.doubleValue + movement.y.doubleValue)
											  Z:@(self.simulatedPosition.z.doubleValue + movement.z.doubleValue)];
		}
		
		double distance = [self.simulatedPosition distanceToPoint:movement];
		duration = MAX(duration, distance / 10000.0);
		self.simulatedPosition = movement;
		
	} else if(G == 90) {
		self.relativeMode = NO;
		
	} else if(G == 91) {
		self.relativeMode = YES;
	}
	
	dispatch_after(dispatch_time(0, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		block(YES, nil);
	});
}


- (TFPPrinterColor)color {
	return TFPPrinterColorOther;
}


- (NSString *)firmwareVersion {
	return @"0000000000";
}


- (void)fetchBacklashValuesWithCompletionHandler:(void(^)(BOOL success, TFPBacklashValues values))completionHandler {
	dispatch_after(dispatch_time(0, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		completionHandler(YES, (TFPBacklashValues){0.33, 0.69, 1500});
	});
}


- (void)fetchBedOffsetsWithCompletionHandler:(void (^)(BOOL, TFPBedLevelOffsets))completionHandler {
	dispatch_after(dispatch_time(0, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		completionHandler(YES, (TFPBedLevelOffsets){-0.30, -0.4, -0.65, -1, -0.95});
	});
}


- (void)establishConnectionWithCompletionHandler:(void(^)(NSError *error))completionHandler {
	self.pendingConnection = YES;
	dispatch_after(dispatch_time(0, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		self.serialNumber = @"TEST-00-00-00-00-123-456";
		self.pendingConnection = NO;
		if(completionHandler) {
			completionHandler(nil);
		}
	});
};


- (void)setBedOffsets:(TFPBedLevelOffsets)offsets completionHandler:(void (^)(BOOL))completionHandler {
	TFLog(@"Dry run setBedOffsets: %@", TFPBedLevelOffsetsDescription(offsets));
	[super setBedOffsets:offsets completionHandler:completionHandler];
}


@end
