//------------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import "MSALTelemetryConfig+Internal.h"

#import "MSIDTelemetryEventInterface.h"
#import "MSALDefaultDispatcher.h"
#import "MSIDTelemetry.h"
#import "MSIDTelemetry+Internal.h"

@implementation MSALTelemetryConfig

+ (instancetype)sharedInstance
{
    static MSALTelemetryConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self.class alloc] init];
    });
    
    return sharedInstance;
}

- (BOOL)piiEnabled { return MSIDTelemetry.sharedInstance.piiEnabled; }
- (void)setPiiEnabled:(BOOL)piiEnabled { [[MSIDTelemetry sharedInstance] setPiiEnabled:piiEnabled]; }

- (void)addDispatcher:(nonnull id<MSALTelemetryDispatcher>)dispatcher setTelemetryOnFailure:(BOOL)setTelemetryOnFailure
{
    MSALDefaultDispatcher *telemetryDispatcher = [[MSALDefaultDispatcher alloc] initWithDispatcher:dispatcher
                                                                             setTelemetryOnFailure:setTelemetryOnFailure];
    
    [[MSIDTelemetry sharedInstance] addDispatcher:telemetryDispatcher];
}

- (void)removeDispatcher:(id<MSALTelemetryDispatcher>)dispatcher
{
    [MSIDTelemetry.sharedInstance findAndRemoveDispatcher:dispatcher];
}

- (void)removeAllDispatchers
{
    [MSIDTelemetry.sharedInstance removeAllDispatchers];
}

@end
