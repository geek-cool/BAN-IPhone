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

//- (void)writeToServer: (float *)outputdata
//{
//    NSLog(@"%x\r\n", outputdata);
//    //NSString *aa = [[NSString alloc] initWithFormat:@"%f",&outputdata];
//    //uint8_t *buf = (uint8_t *)[outputdata UTF8String];
//    //NSLog(@"in");
////    NSLog(@"%s\r\n", buf);
////    int slen = strlen((char *)buf);
////    NSLog(@"%d\r\n", slen);
//    //int len=4;
//    //NSData *se = [NSData dataWithBytes:(const uint8_t *)outputdata length:28];
//    //[se appendBytes:outputdata length:28];
//    //NSLog(@"%@\r\n", [[NSString alloc] initWithData:se encoding:NSUTF8StringEncoding]);
//    double send[7];
//    for (int i =0; i<7; i++)
//    {
//        send[i] = *(outputdata+i);
//        NSLog(@"%f\r\n", send[i]);
//        //[se appendBytes:&send[i] length:sizeof(float)];
//        //NSLog(@"%@\r\n", [[NSString alloc] initWithData:se encoding:NSUTF8StringEncoding]);
//    }
////    for (int j = 0; j<=28; j++)
////    {
////        NSLog(@"%s\r\n", (uint8_t *)send+j);
////    }
//    while ([outputStream hasSpaceAvailable])
//    {
//        //NSLog(@"hasspace");
//        //do {
//            //NSLog("@", buf);
////            [outputStream write:(uint8_t *)slen maxLength:4];
////            [outputStream write:buf maxLength:strlen((char *)buf)];
//            //[outputStream write:(uint8_t *)send maxLength:28];
//        [outputStream write:(const uint8_t *)&send maxLength:56];
//        //NSLog(@"do");
//            sendkey = false;
//            //[self closeNetwork];
//        //} while (len<3);
//        //sendkey = false;
//        //[socketDelegate self];
//        //NSLog(@"write");
//        //NSLog(@"%d",strlen((char *)buf));
//    }
//}
/*int count_T = 0;

- (void)writeToServer:(float)accel_x accel_y:(float)accel_y accel_z:(float)accel_z gyro_x:(float)gyro_x gyro_y:(float)gyro_y gyro_z:(float)gyro_z
{
    
    int count = 0;
    float send[6];
    
    send[0] = accel_x;
    send[1] = accel_y;
    send[2] = accel_z;
    send[3] = gyro_x;
    send[4] = gyro_y;
    send[5] = gyro_z;
    
    //float to string
    NSString *sendaccx = [NSString stringWithFormat: @"%1.6f", accel_x];
    NSString *sendaccy = [NSString stringWithFormat: @"%1.6f", accel_y];
    NSString *sendaccz = [NSString stringWithFormat: @"%1.6f", accel_z];
    NSString *sendgyrox = [NSString stringWithFormat: @"%1.6f", gyro_x];
    NSString *sendgyroy = [NSString stringWithFormat: @"%1.6f", gyro_y];
    NSString *sendgyroz = [NSString stringWithFormat: @"%1.6f", gyro_z];
    
    //    for (int i=0; i<6; i++)
    //    {
    //        NSLog(@"%g\r\n", send[i]);
    //    }
//    while ([outputStream hasSpaceAvailable] && count ==0)
//    {
//        [outputStream write:(const uint8_t *)&send maxLength:6];
//        //sendkey = false;
//        count_T++;
//        NSLog(@"%d",count_T);
//        count++;
//    }
    
    while ([outputStream hasSpaceAvailable] && count ==0)
    {
        NSData *data = [[NSData alloc] initWithData:[sendaccx dataUsingEncoding:NSASCIIStringEncoding]];
        [outputStream write:[data bytes] maxLength:[data length]];
        data = [[NSData alloc] initWithData:[sendaccy dataUsingEncoding:NSASCIIStringEncoding]];
        [outputStream write:[data bytes] maxLength:[data length]];
        data = [[NSData alloc] initWithData:[sendaccz dataUsingEncoding:NSASCIIStringEncoding]];
        [outputStream write:[data bytes] maxLength:[data length]];
        data = [[NSData alloc] initWithData:[sendgyrox dataUsingEncoding:NSASCIIStringEncoding]];
        [outputStream write:[data bytes] maxLength:[data length]];
        data = [[NSData alloc] initWithData:[sendgyroy dataUsingEncoding:NSASCIIStringEncoding]];
        [outputStream write:[data bytes] maxLength:[data length]];
        data = [[NSData alloc] initWithData:[sendgyroz dataUsingEncoding:NSASCIIStringEncoding]];
        [outputStream write:[data bytes] maxLength:[data length]];
        //sendkey = false;
        count_T++;
        NSLog(@"%d",count_T);
        count++;
    }

}*/

int count_T = 0;
- (void)writeToServer:(char)accel_x_high accel_x_low:(char)accel_x_low accel_y_high:(char)accel_y_high accel_y_low:(char)accel_y_low accel_z_high:(char)accel_z_high accel_z_low:(char)accel_z_low gyro_x_high:(char)gyro_x_high gyro_x_low:(char)gyro_x_low gyro_y_high:(char)gyro_y_high gyro_y_low:(char)gyro_y_low gyro_z_high:(char)gyro_z_high gyro_z_low:(char)gyro_z_low
{
    int count = 0;
    char send[12];
    send[0] = accel_x_high;
    send[1] = accel_x_low;
    send[2] = accel_y_high;
    send[3] = accel_y_low;
    send[4] = accel_z_high;
    send[5] = accel_z_low;
    send[6] = gyro_x_high;
    send[7] = gyro_x_low;
    send[8] = gyro_y_high;
    send[9] = gyro_y_low;
    send[10] = gyro_z_high;
    send[11] = gyro_z_low;
//    for (int i=0; i<12; i++)
//    {
//        NSLog(@"%c\r\n", send[i]);
//    }
    while ([outputStream hasSpaceAvailable] && count ==0)
    {
        [outputStream write:(const uint8_t *)&send maxLength:12];
        //sendkey = false;
        count_T++;
        NSLog(@"%d",count_T);
        count++;
    }
}

@end
