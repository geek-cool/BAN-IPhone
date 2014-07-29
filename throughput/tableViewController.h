//
//  tableViewController.h
//  throughput
//
//  Created by EPL on 13/3/1.
//  Copyright (c) 2013年 EPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIBLECBKeyfob.h"
#import "socket.h"
//#import "ViewController.h"

@interface tableViewController : UITableViewController<TIBLECBKeyfobDelegate, UITableViewDataSource>{
    TIBLECBKeyfob *t;
    socketDelegate *socket;
    NSArray *arryInstructions;
    NSMutableArray *arryDevices;
    NSMutableArray *arryConnect;
    NSString *fileName;
    NSString *paths;
    NSString *infile;
    NSString *peripherals;
    NSMutableDictionary *normal_data;
    NSMutableDictionary *retx_data;
    NSMutableDictionary *complete_data;
    
    NSTimer *myTimer;
    
    IBOutlet UIProgressView *TIBLEUIAccelXBar;
    IBOutlet UIProgressView *TIBLEUIAccelYBar;
    IBOutlet UIProgressView *TIBLEUIAccelZBar;
    IBOutlet UIButton *ConnectPeri;
    IBOutlet UITextField *Act;
    
    float                       accX;
    float                       accY;
    float                       accZ;
    float                       GYROX;
    float                       GYROY;
    float                       GYROZ;
    //NSMutableArray *arryDone;
}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (retain, nonatomic) TIBLECBKeyfob *t;
@property (retain, nonatomic) socketDelegate *socket;

@property (nonatomic, retain) IBOutlet UIProgressView *TIBLEUIAccelXBar;
@property (nonatomic, retain) IBOutlet UIProgressView *TIBLEUIAccelYBar;
@property (nonatomic, retain) IBOutlet UIProgressView *TIBLEUIAccelZBar;
@property (nonatomic, retain) IBOutlet UIButton *ConnectPeri;

@property (retain, nonatomic) NSString *fileName;
@property (retain, nonatomic) NSString *paths;
@property (retain, nonatomic) NSString *infile;
@property (retain, nonatomic) NSString *peripherals;

@end
