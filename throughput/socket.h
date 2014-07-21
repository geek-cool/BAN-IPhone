//
//  socket.h
//  throughput
//
//  Created by Howard on 14/1/7.
//  Copyright (c) 2014年 EPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/socket.h>

//@protocol sockDelegate <NSObject>
//@optional
//
//@end

@interface socketDelegate : NSObject  <NSStreamDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    Boolean *sendkey;
}
//@property (weak, nonatomic) IBOutlet UITextField *inputNameField;
//@property (weak, nonatomic) IBOutlet UIView *joinView;
@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;
@property Boolean *sendkey;
//@property (nonatomic,assign) id <sockDelegate> sockdelegate;

//- (void)stream:(NSString *)writeStream handleEvent:(NSStreamEvent)eventCode;

- (void)initNetworkCommunication;
- (void)closeNetwork;
- (void)stream:(NSStream *)writeStream handleEvent:(NSStreamEvent)eventCode;

- (void)writeToServer:(float)accel_x accel_y:(float)accel_y accel_z:(float)accel_z gyro_x:(float)gyro_x gyro_y:(float)gyro_y gyro_z:(float)gyro_z;

@end
