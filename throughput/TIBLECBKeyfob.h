//
//  TIBLECBKeyfob.h
//  TI-BLE-Demo
//
//  Created by Ole Andreas Torvmark on 10/31/11.
//  Copyright (c) 2011 ST alliance AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import "TIBLECBKeyfobDefines.h"
#import "socket.h"


@protocol TIBLECBKeyfobDelegate 
@optional
-(void) keyfobReady;
-(void) tableViewUpdated;

@required
//-(void) dataValuesUpdated:(char*)data;
//-(void) keyValuesUpdated:(char)sw;
//-(void) TXPwrLevelUpdated:(char)TXPwr;
//-()
@end

@protocol accDelegate <NSObject>
@optional

- (void) ValuesUpdated:(int16_t)accel_x accel_y:(int16_t)accel_y accel_z:(int16_t)accel_z gyro_x:(int16_t)gyro_x gyro_y:(int16_t)gyro_y gyro_z:(int16_t)gyro_z seqnum:(int16_t)seqnum address:(NSString*)address;

-(void) RawValuesUpdated:(char)accel_x_high accel_x_low:(char)accel_x_low accel_y_high:(char)accel_y_high accel_y_low:(char)accel_y_low accel_z_high:(char)accel_z_high accel_z_low:(char)accel_z_low gyro_x_high:(char)gyro_x_high gyro_x_low:(char)gyro_x_low gyro_y_high:(char)gyro_y_high gyro_y_low:(char)gyro_y_low gyro_z_high:(char)gyro_z_high gyro_z_low:(char)gyro_z_low;
@end

@interface TIBLECBKeyfob : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate> {
}


@property (nonatomic)   float batteryLevel;
@property (nonatomic)   BOOL key1;
@property (nonatomic)   BOOL key2;
@property (nonatomic)   float x;
@property (nonatomic)   float y;
@property (nonatomic)   float z;
@property (nonatomic)   float accel_x;
@property (nonatomic)   float accel_y;
@property (nonatomic)   float accel_z;
@property (nonatomic)   float gyro_x;
@property (nonatomic)   float gyro_y;
@property (nonatomic)   float gyro_z;
@property (nonatomic)   NSString *address;
@property (nonatomic)   char TXPwrLevel;
@property (nonatomic)   double count;
@property (nonatomic)   int count1;
@property (nonatomic)   int count2;
@property (nonatomic)   int count3;

@property (nonatomic,assign) id <TIBLECBKeyfobDelegate> delegate;
@property (nonatomic,assign) id <accDelegate> accdelegate;
@property (strong, nonatomic)  NSMutableArray *peripherals;
@property (strong, nonatomic)  NSMutableArray *Connectperipherals;

@property (strong, nonatomic) CBCentralManager *CM; 
@property (strong, nonatomic) CBPeripheral *activePeripheral;

@property (strong, nonatomic) UIButton *TIBLEConnectBtn;

-(void) initConnectButtonPointer:(UIButton *)b;
-(void) soundBuzzer:(Byte)buzVal p:(CBPeripheral *)p;
//-(void) readBattery:(CBPeripheral *)p;
-(void) enableAccelerometer:(CBPeripheral *)p;
-(void) disableAccelerometer:(CBPeripheral *)p;
//-(void) enableButtons:(CBPeripheral *)p;
//-(void) disableButtons:(CBPeripheral *)p;
-(void) enableTXPower:(CBPeripheral *)p;
-(void) disableTXPower:(CBPeripheral *)p;


-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p data:(NSData *)data;
-(void) writeValueNSensor:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID  p:(CBPeripheral *)p data:(NSData *)data;
-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p;
-(void) readValueNSensor: (CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID  p:(CBPeripheral *)p;
-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p on:(BOOL)on;
-(void) notificationNSensor:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID  p:(CBPeripheral *)p on:(BOOL)on;


-(UInt16) swap:(UInt16) s;
-(int) controlSetup:(int) s;
-(int) findBLEPeripherals:(int) timeout;
-(const char *) centralManagerStateToString:(int)state;
-(void) scanTimer:(NSTimer *)timer;
-(void) printKnownPeripherals;
-(void) printPeripheralInfo:(CBPeripheral*)peripheral;
-(void) connectPeripheral:(CBPeripheral *)peripheral;
-(void) enblethroughput:(CBPeripheral *)p;

-(void) getAllServicesFromKeyfob:(CBPeripheral *)p;
-(void) getAllCharacteristicsFromKeyfob:(CBPeripheral *)p;
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p;
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service;
-(const char *) UUIDToString:(CFUUIDRef) UUID;
-(const char *) CBUUIDToString:(CBUUID *) UUID;
-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2;
-(int) compareCBUUIDToInt:(CBUUID *) UUID1 UUID2:(UInt16)UUID2;
-(UInt16) CBUUIDToInt:(CBUUID *) UUID;
-(int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2;



@end
