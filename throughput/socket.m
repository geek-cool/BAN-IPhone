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
@synthesize outputKey;
@synthesize output;
@synthesize sendkey;


- (void)initNetworkCommunication
{
    output = [[NSMutableString alloc] init];
    outputKey = false;
    
    uint portNo = 7788;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"140.114.79.55", portNo, &readStream, &writeStream);
    
    if(!CFWriteStreamOpen(writeStream)) {
		NSLog(@"Error, writeStream not open");
		
		return;
	}
    
    CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
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
        case NSStreamEventHasBytesAvailable:
            if (writeStream == inputStream) {
                NSLog(@"ready2222222");
                NSLog(@"Status of outputStream: %i", [outputStream streamStatus]);
                [self readFromServer];
            }
            break;
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


- (void)readFromServer
{
    int count_buffer = 0;
    NSString *str;
    short int buffer[100];
    for (int i=0; i<100; i++) {
        buffer[i] = 0;
    }
    //char sport[1024];
    NSLog(@"in");
    //int slen = strlen((char *)buf);
    int len;
    
    while([inputStream hasBytesAvailable] && count_buffer<=90)
    {
        count_buffer++;
        len = [inputStream read:buffer maxLength:10];
        NSLog(@"Inputstream size: %d",len);
        if (len == 10) {
            printf("server said:");
            for (int i=0; i<5; i++) {
                printf("%hi ",buffer[i]);
                //str = [NSString stringWithFormat:@"%hi", buffer[i]];
                //output = [output stringByAppendingString:str];
                //NSLog(@"%@",output);
            }printf("\n");
            //NSLog(@"server said: %s",buffer);
            [self dealWithOutput:&buffer];
            //len = [inputStream read:sport maxLength:2];
        }
    }
    //[self dealWithOutput:&buffer];
    
}
NSMutableString *tee;
- (void)dealWithOutput:(uint16_t *)receive
{
    NSString *tem = [[NSMutableString alloc] init];
    NSString *sensorName;
    NSString *stepNum;
    NSString *landingProblem;
    NSString *land;
    NSString *heightProblem;
    NSString *height;
    NSString *pronation;
    NSString *pro;
    int16_t temp[100];
    for(int i=0; i<100; i++)
    {
        temp[i] = *(receive+i);
    }printf("out\n");
    for(int i=0;i<5;i++)
    {
        printf("%hi", temp[i]);
    }printf("\n");
    if(temp[0]==1)
    {
        sensorName = [NSString stringWithFormat:@"Accgyro92: "];
    }
    else if(temp[0]==2)
    {
        sensorName = [NSString stringWithFormat:@"Accgyro93: "];
    }
    else if(temp[0]==3)
    {
        sensorName = [NSString stringWithFormat:@"Accgyro94: "];
    }
    else if(temp[0]==4)
    {
        sensorName = [NSString stringWithFormat:@"Accgyro95: "];
    }
    else
        return;
    printf("temp0\n");
    if (temp[1] == 0)
    {
        land = [NSString stringWithFormat:@"O "];
    }
    else if( temp[1] == -1)
    {
        land = [NSString stringWithFormat:@"? "];
    }
    else
    {
        land = [NSString stringWithFormat:@"X "];
    }
    printf("temp1\n");
    if(temp[2] == 0)
    {
        height = [NSString stringWithFormat:@"O "];
    }
    else if(temp[2] == -1)
    {
        height = [NSString stringWithFormat:@"? "];
    }
    else
    {
        height = [NSString stringWithFormat:@"X "];
    }
    printf("temp2\n");
    if(temp[3] == 0)
    {
        pro = [NSString stringWithFormat:@"O "];
    }
    else if(temp[3] == -1)
    {
        pro = [NSString stringWithFormat:@"? "];
    }
    else
    {
        pro = [NSString stringWithFormat:@"X "];
    }
    printf("temp3\n");
    
    stepNum = [NSString stringWithFormat:@"step: %d ", temp[1]];
    landingProblem = [@"landingProblem:" stringByAppendingString:land];
    heightProblem = [@"heightProblem:" stringByAppendingString:height];
    pronation = [@"pronation:" stringByAppendingString:pro];
    
    //tem = [tem stringByAppendingString:sensorName];
    tem = [tem stringByAppendingString:stepNum];
    tem = [tem stringByAppendingString:landingProblem];
    tem = [tem stringByAppendingString:heightProblem];
    tem = [tem stringByAppendingString:pronation];
    tem = [tem stringByAppendingString:@"\n"];
    //NSLog(@"%@",tem);
    if(tee)
        output = [output stringByAppendingString:tee];
    output = [output stringByAppendingString:tem];
    [tee appendString:output];
    NSLog(@"out put %@",output);
    [[self delegate] updateOutput:output];
    output = [[NSMutableString alloc] init];
    //outputKey = true;
    
}


@end
