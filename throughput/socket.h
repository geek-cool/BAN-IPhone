//
//  socket.h
//  throughput
//
//  Created by Howard on 14/1/7.
//  Copyright (c) 2014年 EPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/socket.h>

@protocol outputDelegate <NSObject>
@optional
- (void) updateOutput:(NSString*)output;
@end

@interface socketDelegate : NSObject  <NSStreamDelegate>
{
    id<outputDelegate> delegate;
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    Boolean *sendkey;
    Boolean outputKey;
    //NSMutableString *output;
    
}
//@property (weak, nonatomic) IBOutlet UITextField *inputNameField;
//@property (weak, nonatomic) IBOutlet UIView *joinView;
@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;
@property Boolean outputKey;
@property (nonatomic, retain) NSString *output;
@property Boolean *sendkey;
@property (nonatomic, assign) id<outputDelegate> delegate;

//@property (nonatomic,assign) id <sockDelegate> sockdelegate;

//- (void)stream:(NSString *)writeStream handleEvent:(NSStreamEvent)eventCode;

- (void)initNetworkCommunication;
- (void)closeNetwork;
- (void)stream:(NSStream *)writeStream handleEvent:(NSStreamEvent)eventCode;

- (void)writeToServer:(uint16_t)sensor_num accel_x:(int16_t)accel_x accel_y:(int16_t)accel_y accel_z:(int16_t)accel_z gyro_x:(int16_t)gyro_x gyro_y:(int16_t)gyro_y gyro_z:(int16_t)gyro_z seqnum:(int16_t)seqnum;
- (void)writeToServer1;
- (void)readFromServer;
- (void)dealWithOutput:(uint16_t *)receive;

@end
