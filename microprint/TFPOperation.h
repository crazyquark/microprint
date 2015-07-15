//
//  TFPOperation.h
//  microprint
//
//  Created by Tomas Franzén on Sat 2015-07-11.
//  Copyright (c) 2015 Tomas Franzén. All rights reserved.
//

@import Foundation;
#import "TFPPrinter.h"

@interface TFPOperation : NSObject
- (instancetype)initWithPrinter:(TFPPrinter*)printer;

@property (readonly, weak) TFPPrinter *printer;
@property (readonly) NSString *activityDescription;

- (void)start;
- (void)ended;
@end
