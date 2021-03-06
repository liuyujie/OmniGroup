// Copyright 2004-2005, 2007, 2014 Omni Development, Inc. All rights reserved.
//
// This software may only be used and reproduced according to the
// terms in the file OmniSourceLicense.html, which should be
// distributed with this project and can also be found at
// <http://www.omnigroup.com/developer/sourcecode/sourcelicense/>.

#import <OmniFoundation/OFObject-Queue.h>
#import <OmniFoundation/NSDate-OFExtensions.h>

RCS_ID("$Id$");

@interface TestObject : NSObject
+ (void)grabMainThreadLock;
+ (void)heartbeat;
+ (void)printCount;
@end

#define THREAD_COUNT 100
#define LOCK_COUNT 100

int main(int argc, char *argv[])
{
    @autoreleasepool {
        id target;
    
        [OBPostLoader processClasses];
        target = [TestObject class];
        unsigned int count = THREAD_COUNT;
        NSLog(@"Detaching %d threads which will each grab the main thread lock %d times", THREAD_COUNT, LOCK_COUNT);
        [NSThread detachNewThreadSelector:@selector(heartbeat) toTarget:target withObject:nil];
        while (count-- != 0)
            [NSThread detachNewThreadSelector:@selector(grabMainThreadLock) toTarget:target withObject:nil];
    }
    @autoreleasepool {
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}

@implementation TestObject

static unsigned int completedLockCount; // Protected by the main thread's lock

+ (void)grabMainThreadLock;
{
    unsigned int count = LOCK_COUNT;

    while (count--) {
        @autoreleasepool {
            [NSThread lockMainThread];
            completedLockCount++;
            [NSThread unlockMainThread];
            [[NSDate dateWithTimeIntervalSinceNow:0.01] sleepUntilDate];
        }
    }
}

+ (void)heartbeat;
{
    while (YES) {
        @autoreleasepool {
            [self mainThreadPerformSelector:@selector(printCount)];
            [[NSDate dateWithTimeIntervalSinceNow:0.25] sleepUntilDate];
        }
    }
}

+ (void)printCount;
{
    NSLog(@"%d locks complete", completedLockCount);
    if (completedLockCount == THREAD_COUNT * LOCK_COUNT)
        exit(0);
}

@end
