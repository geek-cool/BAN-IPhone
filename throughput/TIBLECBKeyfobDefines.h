//
//  TIBLECBKeyfobDefines.h
//  TI-BLE-Demo
//
//  Created by Ole Andreas Torvmark on 10/31/11.
//  Copyright (c) 2011 ST alliance AS. All rights reserved.
//

#ifndef TI_BLE_Demo_TIBLECBKeyfobDefines_h
#define TI_BLE_Demo_TIBLECBKeyfobDefines_h

// Defines for the TI CC2540 keyfob peripheral

#define TI_KEYFOB_PROXIMITY_ALERT_UUID                      0x1802
#define TI_KEYFOB_PROXIMITY_ALERT_PROPERTY_UUID             0x2a06
#define TI_KEYFOB_PROXIMITY_ALERT_ON_VAL                    0x01
#define TI_KEYFOB_PROXIMITY_ALERT_OFF_VAL                   0x00
#define TI_KEYFOB_PROXIMITY_ALERT_WRITE_LEN                 1
#define TI_KEYFOB_PROXIMITY_TX_PWR_SERVICE_UUID             0x1804
#define TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_UUID        0x2A07
#define TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_READ_LEN    1

//
#define TI_KEYFOB_BATT_SERVICE_UUID                         0x180F
#define TI_KEYFOB_LEVEL_SERVICE_UUID                        0x2A19
#define TI_KEYFOB_POWER_STATE_UUID                          0xFFB2
#define TI_KEYFOB_LEVEL_SERVICE_READ_LEN                    1
//

#define TI_KEYFOB_ACCEL_SERVICE_UUID                        0xFFA0//
#define TI_KEYFOB_ACCEL_ENABLER_UUID                        0xFFA1
#define TI_KEYFOB_ACCEL_RANGE_UUID                          0xFFA2
#define TI_KEYFOB_ACCEL_READ_LEN                            2
#define TI_KEYFOB_ACCEL_X_UUID                              0xFFA3
#define TI_KEYFOB_ACCEL_Y_UUID                              0xFFA4
#define TI_KEYFOB_ACCEL_Z_UUID                              0xFFA5
#define TI_KEYFOB_ACCEL_XYZ_UUID                            0xFFA6
#define TI_KEYFOB_ACCEL_MULTI_XYZ_UUID                      0xFFA7
#define GYRU_SERVICE_UUID                                   0xFFD0
#define GYRU_ENABLER_UUID                                   0xFFD1
#define GYRU_MULTI_XYZ_UUID                                 0xFFD7
#define ACCEL_GYRU_SERVICE_UUID                             0xFFC0
#define ACCEL_GYRU_ENABLER_UUID                             0xFFC1
#define ACCEL_GYRU_XYZ_UUID                                 0xFFC7

//#define TI_KEYFOB_THROUGHPUT_SERVICE_UUID                   0xFFC0
//#define TI_KEYFOB_THROUGHPUT_UUID                           0xFFC1
//#define TI_KEYFOB_THROUGHPUT_LEN                            20

#define NPlusSensor_SERVICE_UUID [CBUUID UUIDWithString: @"F1D30565-C50E-C833-E608-F2D491A8928C"]
#define NPlusSensor_ENABLER_UUID [CBUUID UUIDWithString: @"F1FE195A-9067-2481-848D-3D7CF2A45191"]
#define NPlusSensor_NOTI1_UUID [CBUUID UUIDWithString: @"F230DF58-D1B0-8EDD-3327-28B3C5A7BAC3"]
#define NPlusSensor_NOTI2_UUID [CBUUID UUIDWithString: @"F230DF48-9067-2481-848D-BB04B2B0F6C0"]
#define NPlusSensor_NOTI3_UUID [CBUUID UUIDWithString: @"F230DF4F-B00B-ED7D-92C7-A4C6D31444E3"]
#define NPlusSensor_NOTI4_UUID [CBUUID UUIDWithString: @"F230DF4D-D97D-66B3-9173-B185EEFE84FE"]

//
#define TI_KEYFOB_KEYS_SERVICE_UUID                         0xFFE0//
#define TI_KEYFOB_KEYS_NOTIFICATION_UUID                    0xFFE1
#define TI_KEYFOB_KEYS_NOTIFICATION_READ_LEN                1
//

#endif
