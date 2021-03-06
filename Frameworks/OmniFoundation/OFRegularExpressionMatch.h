// Copyright 1997-2005, 2007, 2010, 2012, 2013 The Omni Group. All rights reserved.
//
// This software may only be used and reproduced according to the
// terms in the file OmniSourceLicense.html, which should be
// distributed with this project and can also be found at
// <http://www.omnigroup.com/developer/sourcecode/sourcelicense/>.
//
// $Id$

#import <Foundation/NSObject.h>

@class NSTextCheckingResult;
@class OFStringScanner;

@interface OFRegularExpressionMatch : NSObject

- initWithTextCheckingResult:(NSTextCheckingResult *)textCheckingResult string:(NSString *)string;
- initWithTextCheckingResult:(NSTextCheckingResult *)textCheckingResult stringScanner:(OFStringScanner *)stringScanner;

@property(nonatomic,readonly) NSRange matchRange; // Range of the full match
@property(nonatomic,readonly) NSString *matchString;

- (NSString *)captureGroupAtIndex:(NSUInteger)captureGroupIndex; // Zero is the first capture (not the full match).
- (NSRange)rangeOfCaptureGroupAtIndex:(NSUInteger)captureGroupIndex;

// Returns nil if there is another match in the string, or stringScanner. If the receiver is initialized with a string scanner, this will advance the scan location on success.
- (OFRegularExpressionMatch *)nextMatch;

@end
