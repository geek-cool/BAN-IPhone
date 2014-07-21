//
//  tblViewController.m
//  ble_demo
//
//  Created by EPL on 12/11/27.
//  Copyright (c) 2012年 EPL. All rights reserved.
//

#import "tableViewController.h"
#import "socket.h"

@interface tableViewController ()

@end

@implementation tableViewController

@synthesize spinner,t;
@synthesize TIBLEUIAccelXBar;
@synthesize TIBLEUIAccelYBar;
@synthesize TIBLEUIAccelZBar;
@synthesize ConnectPeri;

@synthesize fileName, paths, infile;

@synthesize peripherals;
NSMutableArray *message;

int pcount;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    socket = [[socketDelegate alloc] init];
    [socket initNetworkCommunication];
    message = [[NSMutableArray alloc] init];
    
    
    t = [[TIBLECBKeyfob alloc] init];   // Init TIBLECBKeyfob class.
    [t controlSetup:1];                 // Do initial setup of TIBLECBKeyfob class.
    t.delegate = self;
    arryInstructions = [[NSArray alloc] initWithObjects:@"Scan",nil];
    //arryDevices = [[NSMutableArray alloc] initWithObjects:@"epl", nil];
    arryDevices = [[NSMutableArray alloc] init];
    arryConnect = [[NSMutableArray alloc] init];
    //arryDone = [[NSMutableArray alloc] init];
    
    [ConnectPeri addTarget:self action:@selector(handleButtonClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tableViewUpdated{
    [arryDevices removeAllObjects];
    [arryConnect removeAllObjects];
    [arryDevices addObjectsFromArray:t.peripherals];
    [arryConnect addObjectsFromArray:t.Connectperipherals];

    NSLog(@"tableviewupdated\r\n");
    if ([arryConnect count] > pcount) {
        [myTimer invalidate];
        myTimer = nil;
        
        [t enableAccelerometer:[t activePeripheral]];
        t.accdelegate = self;
            
        NSLog(@">>>>>>>>>Enable");
    }
    [spinner stopAnimating];
    
    [self.tableView reloadData];
}

-(void) connectionTimer:(NSTimer *)timer {
    CBPeripheral *p = [timer userInfo];
    [t connectPeripheral:p];
    
}

/*
-(IBAction) handleButtonClick:(id)sender
{
    int devicecounter;
    for (devicecounter=0;devicecounter<[arryDevices count];devicecounter++) {
        UITableViewCell *cell = arryDevices[devicecounter];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSLog(@">>>>>>>INDEXPATH%@\r\n", indexPath);
        CBPeripheral *p = [arryDevices objectAtIndex:indexPath.row];
        [NSTimer scheduledTimerWithTimeInterval:(float)0.0 target:self selector:@selector(connectionTimer:) userInfo:p repeats:NO];
        cell.textLabel.textColor = [UIColor blueColor];
        
        indexPath = [self.tableView indexPathForCell:cell];
        [t enableAccelerometer:[t activePeripheral]];
        t.accdelegate = self;
 
        NSLog(@">>>>>>>>>Enable");
        [self.tableView reloadData];
    }
}
*/

/*-(void) keyfobReady {
 [t enableAccelerometer:[t activePeripheral]];   // Enable accelerometer (if found)
 }*/

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(section == 0){
		return @"";
	}
    else if (section == 1){
        return @"Connected";
    }
    else{
		return @"Unconnected";
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0){
		return [arryInstructions count];
    }
    /*else if(section == 1)
    {
        return [arryDone count];
    }*/
    else if(section == 1)
    {
        return [arryConnect count];
    }
	else
    {
		return [arryDevices count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Set up the cell...
	if(indexPath.section == 0){
        cell.textLabel.text = [arryInstructions objectAtIndex:indexPath.row];
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        cell.accessoryView = spinner;
	}
    /*
    else if(indexPath.section == 1){
        CBPeripheral *p = [arryDone objectAtIndex:indexPath.row];
		cell.textLabel.text = (NSString*)p.name;
        //cell.textLabel.text = [arryDevices objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    */
    else if(indexPath.section == 1){
        
        CBPeripheral *p = [arryConnect objectAtIndex:indexPath.row];
		cell.textLabel.text = (NSString*)p.name;
        //cell.textLabel.text = [arryDevices objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.textLabel.textColor = [UIColor blueColor];
    }
    
    else{
        CBPeripheral *p = [arryDevices objectAtIndex:indexPath.row];
		cell.textLabel.text = (NSString*)p.name;
        //cell.textLabel.text = [arryDevices objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.textLabel.textColor = [UIColor blackColor];
	}
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    pcount = [arryConnect count];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //NSLog(@">>>>>>>INDEXPATH%@\r\n", indexPath);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 0){
        [spinner startAnimating];
        if(t.peripherals) t.peripherals = nil;
        [t findBLEPeripherals:1];
        
    }
    else if(indexPath.section == 1){
        CBPeripheral *p = [arryConnect objectAtIndex:indexPath.row];
        [[t CM] cancelPeripheralConnection:p];
        [t disableAccelerometer:p];
        [arryConnect removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        printf("cancel Peripheral Connection!\r\n");
    }
    else{
        NSLog(@"pressed 3\r\n");

        CBPeripheral *p = [arryDevices objectAtIndex:indexPath.row];
        myTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.5 target:self selector:@selector(connectionTimer:) userInfo:p repeats:YES];

        cell.textLabel.textColor = [UIColor blueColor];
        NSLog(@"p:%d connect count:%d\r\n", pcount, [arryConnect count]);
        [self tableViewUpdated];
    }
}
/*
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    //ViewController *vc = [self.storyboard instantiateInitialViewController:@"test"];
    //CBPeripheral *p = [arryConnect objectAtIndex:indexPath.row];
    //[t enblethroughput:p];
    /*
    ViewController *vc = [[ViewController alloc] init];
    vc.t = self.t;
    [self.navigationController pushViewController:vc animated:YES];*/
    //NSLog(@">>>>>>>>>View");
    /*ViewController *vc = [[ViewController alloc] init];
    vc.t = self.t;
    //[self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
    [t enableAccelerometer:[t activePeripheral]];*/
   /*
    [t enableAccelerometer:[t activePeripheral]];
    t.accdelegate = self;
    
    NSLog(@">>>>>>>>>Enable");
}*/

//int position = 0;

- (void) ValuesUpdated:(int16_t)accel_x accel_y:(int16_t)accel_y accel_z:(int16_t)accel_z gyro_x:(int16_t)gyro_x gyro_y:(int16_t)gyro_y gyro_z:(int16_t)gyro_z seqnum:(int16_t)seqnum address:(NSString*)address
{
    
    if (counter_n[0]>2000) {
        [self tableViewUpdated];
        counter_n[0]=0;
    }
    counter_n[0]++;
    accX = (float)(accel_x) / 16 / 256;
    accY = (float)(accel_y) / 16 / 256;
    accZ = (float)(accel_z) / 16 / 256;
    GYROX = (float)(gyro_x)/16/256*250;
    GYROY = (float)(gyro_y)/16/256*250;
    GYROZ = (float)(gyro_z)/16/256*250;    

    
    TIBLEUIAccelXBar.progress = (accX*16 +100)/ 200;
    TIBLEUIAccelYBar.progress = (accY*16 +100)/ 200;
    TIBLEUIAccelZBar.progress = (accZ*16 +100)/ 200;
    
    double ss = CFAbsoluteTimeGetCurrent();
    ss =  (ss - floor(ss/1000)*1000);
    
    
    if([address isEqualToString:@"AccGyro92"]) {
        //position = 1;
        [self HandleOutput:1 ss:ss accx:accel_x accy:accel_y accz:accel_z GYROx:gyro_x GYROy:gyro_y GYROz:gyro_z seqnum:(uint16_t)seqnum address:(NSString*)address];
    }
    
    else  if([address isEqualToString:@"AccGyro93"]) {
        //position = 2;
        [self HandleOutput:2 ss:ss accx:accel_x accy:accel_y accz:accel_z GYROx:gyro_x GYROy:gyro_y GYROz:gyro_z seqnum:(uint16_t)seqnum address:(NSString*)address];
    }
    
    else if([address isEqualToString:@"AccGyro94"]) {
        //position = 3;        
        [self HandleOutput:3 ss:ss accx:accel_x accy:accel_y accz:accel_z GYROx:gyro_x GYROy:gyro_y GYROz:gyro_z seqnum:(uint16_t)seqnum address:(NSString*)address];
    }
    
    else if([address isEqualToString:@"AccGyro95"]) {
        //position = 4;
        [self HandleOutput:4 ss:ss accx:accel_x accy:accel_y accz:accel_z GYROx:gyro_x GYROy:gyro_y GYROz:gyro_z seqnum:(uint16_t)seqnum address:(NSString*)address];
        
    }
    else;
    //position = 0;
}

//int counter = 0;

int counter_n[5] = {0, 0, 0, 0, 0};
int counter_r[5] = {0, 0, 0, 0, 0};
int16_t buffer_Acc_GYRO_send[5][300][6];
float buffer_Acc_GYRO_write[5][300][6];
float buffer_Acc_GYRO_retx[5][300][7];
float buffer_time[5][300];
float buffer_time_retx[5][300];
uint16_t buffer_seqnum[5][300];
uint16_t buffer_seqnum_retx[5][300];
int first_data[5] = {1, 1, 1, 1, 1}, loss_num, after_write[5] = {0, 0 , 0, 0, 0}, after_write_r[5] = {0, 0 , 0, 0, 0}, last_index[5] = {0, 0 , 0, 0, 0}, last_index_r[5] = {0, 0 , 0, 0, 0};

- (void) HandleOutput: (int)np ss:(float)ss accx:(int16_t)accx accy:(int16_t)accy accz:(int16_t)accz GYROx:(int16_t)GYROx GYROy:(int16_t)GYROy GYROz:(int16_t)GYROz seqnum:(int16_t)seqnum address:(NSString*)address
{
    NSString* file_address = nil;

    if(first_data[np] == 0)
    {
        loss_num = seqnum - buffer_seqnum[np][counter_n[np]-1] - 1;
    }
    else if(first_data[np] == 1)
    {
        loss_num = 0;
        first_data[np] = 0;
    }
    else if(after_write[np] == 1)
    {
        loss_num = seqnum - buffer_seqnum[np][last_index[np]] - 1;
        after_write[np] = 0;
    }/*
    else if(after_write_r[np] == 1)
    {
        
    }*/
    else
    {
        NSLog(@"Unknow loss number");
    }
    NSLog(@"LN:%d SQ:%d\r\n", loss_num, seqnum);

    if(loss_num < 0)
    {
        int counter = counter_r[np];
        buffer_time_retx[np][counter] = ss;
        buffer_Acc_GYRO_retx[np][counter][0] = (float)(accx)/16/256;
        buffer_Acc_GYRO_retx[np][counter][1] = (float)(accy)/16/256;
        buffer_Acc_GYRO_retx[np][counter][2] = (float)(accz)/16/256;
        buffer_Acc_GYRO_retx[np][counter][3] = (float)(GYROx)/16/256*250;
        buffer_Acc_GYRO_retx[np][counter][4] = (float)(GYROy)/16/256*250;
        buffer_Acc_GYRO_retx[np][counter][5] = (float)(GYROz)/16/256*250;
        buffer_seqnum_retx[np][counter] = seqnum;
        
        counter_r[np]++;
    }
    else
    {
        int counter = counter_n[np];
        buffer_time[np][counter] = ss;
        buffer_Acc_GYRO_send[np][counter][0] = accx;
        buffer_Acc_GYRO_send[np][counter][1] = accy;
        buffer_Acc_GYRO_send[np][counter][2] = accz;
        buffer_Acc_GYRO_send[np][counter][3] = GYROx;
        buffer_Acc_GYRO_send[np][counter][4] = GYROy;
        buffer_Acc_GYRO_send[np][counter][5] = GYROz;
        buffer_seqnum[np][counter] = seqnum;
        
        counter_n[np]++;
    }
    
    
    if (counter_n[np] >200) {
        //寫入檔案
        for (int i=0;i<counter_n[np];i++) {
            // get path to Documents/address.txt
            //NSLog(@"before : %hi %hi %hi %hi %hi %hi",buffer_Acc_GYRO_send[np][i][0],buffer_Acc_GYRO_send[np][i][1],buffer_Acc_GYRO_send[np][i][2],buffer_Acc_GYRO_send[np][i][3],buffer_Acc_GYRO_send[np][i][4],buffer_Acc_GYRO_send[np][i][5]);
            buffer_Acc_GYRO_write[np][i][0] = (float)(buffer_Acc_GYRO_send[np][i][0]) / 16 / 256;
            buffer_Acc_GYRO_write[np][i][1] = (float)(buffer_Acc_GYRO_send[np][i][1]) / 16 / 256;
            buffer_Acc_GYRO_write[np][i][2] = (float)(buffer_Acc_GYRO_send[np][i][2]) / 16 / 256;
            buffer_Acc_GYRO_write[np][i][3] = (float)(buffer_Acc_GYRO_send[np][i][3])/16/256*250;
            buffer_Acc_GYRO_write[np][i][4] = (float)(buffer_Acc_GYRO_send[np][i][4])/16/256*250;
            buffer_Acc_GYRO_write[np][i][5] = (float)(buffer_Acc_GYRO_send[np][i][5])/16/256*250;
            //NSLog(@"before : %f %f %f %f %f %f",buffer_Acc_GYRO_write[np][i][0],buffer_Acc_GYRO_write[np][i][1],buffer_Acc_GYRO_write[np][i][2],buffer_Acc_GYRO_write[np][i][3],buffer_Acc_GYRO_write[np][i][4],buffer_Acc_GYRO_write[np][i][5]);
            NSArray *pathsa = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [pathsa objectAtIndex:0];
            //NSLog(@"save to %@\n", address);
            file_address = [NSString stringWithFormat:@"%@.csv", address];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:file_address];
            
            // create if needed
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
                [[NSData data] writeToFile:path atomically:YES];
            }
            
            // append
            NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
            [handle truncateFileAtOffset:[handle seekToEndOfFile]];
            
            
            NSString *outS = [NSString stringWithFormat:@"%f,%f,%f,%f,%f,%f,%f,%hu\r\n", buffer_time[np][i], buffer_Acc_GYRO_write[np][i][0],buffer_Acc_GYRO_write[np][i][1], buffer_Acc_GYRO_write[np][i][2], buffer_Acc_GYRO_write[np][i][3], buffer_Acc_GYRO_write[np][i][4],buffer_Acc_GYRO_write[np][i][5], buffer_seqnum[np][i]];
            //NSLog(@"out%@",outS);
            [handle writeData:[outS dataUsingEncoding:NSUTF8StringEncoding]];
        }
        last_index[np] = counter_n[np]-1;
        after_write[np] = 1;
        counter_n[np] = 0;
    }
    if (counter_r[np] >200) {
        //寫入檔案
        for (int i=0;i<counter_r[np];i++) {

            NSArray *pathsa = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [pathsa objectAtIndex:0];
            //NSLog(@"save to %@\n", address);
            file_address = [NSString stringWithFormat:@"%@_retx.csv", address];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:file_address];
            
            // create if needed
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
                [[NSData data] writeToFile:path atomically:YES];
            }
            
            // append
            NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
            [handle truncateFileAtOffset:[handle seekToEndOfFile]];
            
            
            NSString *outS = [NSString stringWithFormat:@"%f,%f,%f,%f,%f,%f,%f,%hu\r\n", buffer_time_retx[np][i], buffer_Acc_GYRO_retx[np][i][0],buffer_Acc_GYRO_retx[np][i][1], buffer_Acc_GYRO_retx[np][i][2], buffer_Acc_GYRO_retx[np][i][3], buffer_Acc_GYRO_retx[np][i][4],buffer_Acc_GYRO_retx[np][i][5], buffer_seqnum_retx[np][i]];
            //NSLog(@"out%@",outS);
            [handle writeData:[outS dataUsingEncoding:NSUTF8StringEncoding]];
        }
        //last_index_r[np] = counter_r[np]-1;
        //after_write_r[np] = 1;
        counter_r[np] = 0;
    }
}


@end