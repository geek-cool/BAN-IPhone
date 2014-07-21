//
//  socket.h
//  throughput
//
//  Created by Howard on 14/1/7.
//  Copyright (c) 2014年 EPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/socket.h>

@interface ViewController : UIViewController <NSStreamDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}
@property (weak, nonatomic) IBOutlet UITextField *inputNameField;
@property (weak, nonatomic) IBOutlet UIView *joinView;
@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;

//- (void)stream:(NSString *)writeStream handleEvent:(NSStreamEvent)eventCode;

@end
