//
//  ViewController.m
//  CorePlotTest
//
//  Created by gong wen kai on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize t;

-(void) viewDidLoad
{    
    NSLog(@">>>>>IN ViewController");
    //t.delegate = self;
    t.accdelegate = self;
    NSLog(@"assign accdelegate = %@",t.accdelegate);
    
    //[t enblethroughput:[t activePeripheral]];
    //printf("enter\r\n");
    self.textView = [[UITextView alloc] initWithFrame:self.view.frame]; //初始化大小并自动释放
    self.textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    self.textView.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小
    self.textView.delegate = self;//设置它的委托方法
    self.textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    //printf("array[0] = %s", [[temp2 objectAtIndex: 0] cString]);

   // self.textView.text = temp2[0];
    
    self.textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
   // self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    self.textView.scrollEnabled = YES;//是否可以拖动
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度    
    
    [self.view addSubview: self.textView];//加入到整个页面中
    [self.textView reloadInputViews];
    timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dataOpt) userInfo:nil repeats:YES];
    [timer1 fire];
}

///*
-(void) accelerometerValuesUpdated:(char)x y:(char)y z:(char)z //(char*) data
{
    accX = (float)(x) / 64;
    accY = (float)(y) / 64;
    accZ = (float)(z) / 64;
    NSLog(@"%lf, %lf, %lf\r\n", accX, accY, accZ);
    /*
    printf("lalala\r\n");
    //NSLog(@"%@\r\n", throughput);
    NSLog(@"%@\r\n", temp2);
    temp2[0] = data[0];
    printf("data = %d", data[0]);

    printf("okokok\r\n");*/
}///*/

- (void) dataOpt
{
    //printf("get = %d",temp2[0] );
    NSLog(@"dataopt");
    
    printf("%lf, %lf, %lf\r\n", accX, accY, accZ);
    //刷新画板
    //[graph reloadData];
    //j = j + 20;
    //r = r + 20;
}


@end
