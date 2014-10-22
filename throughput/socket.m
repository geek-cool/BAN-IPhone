//
//  ViewController.m
//  Socket_test
//
//  Created by lab731 on 2013/12/31.
//  Copyright (c) 2013年 lab731. All rights reserved.
//

#import "socket.h"

@implementation socketDelegate
@synthesize inputStream;
@synthesize outputStream;
@synthesize sendkey;

- (void)initNetworkCommunication
{
    uint portNo = 1234;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"140.114.79.174", portNo, &readStream, &writeStream);
    
    if(!CFWriteStreamOpen(writeStream)) {
		NSLog(@"Error, writeStream not open");
		
		return;
	}
    
    CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    //inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    //[inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    //[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //[inputStream open];
    [outputStream open];
    NSLog(@"Status of outputStream: %i", [outputStream streamStatus]);
    
}

- (void)closeNetwork
{
    [outputStream close];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream setDelegate:Nil];
    outputStream = nil;
}

#pragma mark - Delegate
- (void)stream:(NSStream *)writeStream handleEvent:(NSStreamEvent)eventCode
{
    NSLog(@"Stream triggered.");
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Status of outputStream: %i", [outputStream streamStatus]);
            NSLog(@"oPEN.");
            break;
            /*case NSStreamEventHasSpaceAvailable:
             NSLog(@"outputStream is available.");
             if(Stream == outputStream)
             {
             NSLog(@"outputStream is ready.");
             NSString *str = @"abc";
             //uint8_t *buf = (uint8_t *)[str UTF8String];
             uint8_t *buf = (uint8_t *)[str cStringUsingEncoding:NSASCIIStringEncoding];
             //uint8_t *a = 'b';
             //uint8_t *aa = 50;
             //NSLog(@"Status of outputStream: %i", [outputStream streamStatus]);
             NSLog(@"data: %@", str);
             NSLog(@"data2: %s", buf);
             //[outputStream write:buf maxLength:strlen((char *)buf)];
             [outputStream write:buf maxLength:strlen((char *)buf)];
             NSLog(@"Status of outputStream: %i", [outputStream streamStatus]);
             
             }
             break;*/
        case NSStreamEventHasSpaceAvailable:
            if (writeStream == outputStream)
            {
                NSLog(@"ready");
                NSLog(@"Status of outputStream: %i", [outputStream streamStatus]);
                sendkey = TRUE;
                //[self writeToServer];
            }
            break;
        case NSStreamEventNone:
            NSLog(@"Status of outputStream: %i", [outputStream streamStatus]);
            NSLog(@"No event.");
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"Status of outputStream: %i", [outputStream streamStatus]);
            NSLog(@"eRROR");
            [self closeNetwork];
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"Status of outputStream: %i", [outputStream streamStatus]);
            NSLog(@"end");
            [self closeNetwork];
            break;
        default:
        {
            //NSLog(@"Stream is sending an Event: %i",eventCode);
        }
            break;
    }
    
}
int count_T = 0;

- (void)writeToServer:(uint16_t)sensor_num accel_x:(int16_t)accel_x accel_y:(int16_t)accel_y accel_z:(int16_t)accel_z gyro_x:(int16_t)gyro_x gyro_y:(int16_t)gyro_y gyro_z:(int16_t)gyro_z seqnum:(int16_t)seqnum
{
    int count = 0;
    int16_t send[8];
    send[0] = sensor_num;
    send[1] = accel_x;
    send[2] = accel_y;
    send[3] = accel_z;
    send[4] = gyro_x;
    send[5] = gyro_y;
    send[6] = gyro_z;
    send[7] = seqnum;
    //    for (int i=0; i<12; i++)
    //    {
    //        NSLog(@"%c\r\n", send[i]);
    //    }
    while ([outputStream hasSpaceAvailable] && count ==0)
    {
        [outputStream write:(const uint8_t *)&send maxLength:16];
        //sendkey = false;
        count_T++;
        NSLog(@"%d",count_T);
        count++;
    }
}

@end
