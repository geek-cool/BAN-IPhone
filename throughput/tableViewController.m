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
    
    normal_data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1", [[NSMutableArray alloc]init], @"2", [[NSMutableArray alloc]init], @"3", [[NSMutableArray alloc]init], @"4", [[NSMutableArray alloc]init], nil];
    retx_data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1", [[NSMutableArray alloc]init], @"2", [[NSMutableArray alloc]init], @"3", [[NSMutableArray alloc]init], @"4", [[NSMutableArray alloc]init], nil];
    complete_data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1", [[NSMutableArray alloc]init], @"2", [[NSArray alloc]init], @"3", [[NSMutableArray alloc]init], @"4", [[NSMutableArray alloc]init], nil];
    
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
        
        NSLog(@"array acount: %d", [arryConnect count]);
        if([arryConnect count]==0)
        [self reorder_handler];
        //[self save];
        
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
    
   /* if (counter_n[0]>2000) {
        [self tableViewUpdated];
        counter_n[0]=0;
    }
    counter_n[0]++;*/
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

int first_data[5] = {1, 1, 1, 1, 1}, last_index[5] = {0, 0 , 0, 0, 0};
- (void) HandleOutput: (int)np ss:(float)ss accx:(int16_t)accx accy:(int16_t)accy accz:(int16_t)accz GYROx:(int16_t)GYROx GYROy:(int16_t)GYROy GYROz:(int16_t)GYROz seqnum:(int16_t)seqnum address:(NSString*)address
{
    int loss_num;
    NSString *dic_key = [[NSString alloc] init];
    NSNumber *time = [NSNumber numberWithFloat:ss];
    NSNumber *ax = [NSNumber numberWithInt:accx];
    NSNumber *ay = [NSNumber numberWithInt:accy];
    NSNumber *az = [NSNumber numberWithInt:accz];
    NSNumber *gx = [NSNumber numberWithInt:GYROx];
    NSNumber *gy = [NSNumber numberWithInt:GYROy];
    NSNumber *gz = [NSNumber numberWithInt:GYROz];
    NSNumber *seq = [NSNumber numberWithInt: seqnum];

    NSArray *tem = [[NSArray alloc]initWithObjects:time, ax, ay, az, gx, gy, gz, seq, nil];

    dic_key = [self dic_key_decide: np];
    
    if(first_data[np] == 0)
    {
        loss_num = seqnum - last_index[np] - 1;
        last_index[np] = seqnum;
    }
    else
    {
        NSMutableArray *tem_dic = [[NSMutableArray alloc] init];
        [tem_dic addObject:tem];
        [normal_data setValue:tem_dic forKey:dic_key];
        last_index[np] = seqnum;
        first_data[np] = 0;
        return;
    }
        //NSLog(@"loss: %d", loss_num);
    if(loss_num < 0)
    {
        NSMutableArray *tem_dic = [[NSMutableArray alloc] init];
        [tem_dic addObject:tem];
        [retx_data setValue:tem_dic forKeyPath:dic_key];
        //[[retx_data valueForKey:dic_key] addObject:tem];
        //NSLog(@"loss num: %d, %@",loss_num, [retx_data valueForKey:dic_key]);
        //[self reorder:seqnum];
    }
    else
    {   NSMutableArray *tem_dic = [normal_data valueForKey:dic_key];
        [tem_dic addObject:tem];
        [normal_data setValue:tem_dic forKey:dic_key];
    }
}

- (NSString *) dic_key_decide:(int)sen_num
{
    NSString *key;
    switch (sen_num)
    {
        case 1:
            key = [[NSString alloc] initWithString:@"1"];
            break;
        case 2:
            key = [[NSString alloc] initWithString:@"2"];
            break;
        case 3:
            key = [[NSString alloc] initWithString:@"3"];
            break;
        case 4:
            key = [[NSString alloc] initWithString:@"4"];
            break;
            
        default:
            key = [[NSString alloc] initWithString:@"Error"];
            break;
    }
    return key;
}

- (void) reorder_handler
{//NSLog(@"reorder");
    NSString *key = [[NSString alloc] init];
    NSMutableArray *tem_nor = [[NSMutableArray alloc] init];
    NSMutableArray *tem_re = [[NSMutableArray alloc] init];
    NSMutableArray *tem_com = [[NSMutableArray alloc] init];
    //NSSortDescriptor *sortdescriptor;
    //NSArray *sortdescriptors = [[NSArray alloc] init];
    //NSArray *tem_sort = [[NSArray alloc] init];
    
    for(int i=1; i<5; i++)
    {
        int re_key = 0, sort_key = 0;
        key = [self dic_key_decide:i];
        //NSLog(@"after switch: %@", key);
        
        tem_nor = [normal_data valueForKey:key];
        tem_re = [retx_data valueForKey:key];
        if(tem_nor!= NULL)
        {//NSLog(@"normal");
            [tem_com addObject:tem_nor];
            NSString *add = [NSString stringWithFormat:@"normal_data_%@",key];
            //NSLog(@"Save normal");
            [self save:normal_data address:add key:key];//NSLog(@"nor: %@",normal_data);
            add = nil;
        }
        else
        {//NSLog(@"no_nor");
            key = NULL;
            continue;
        }
        if(tem_re!=NULL)
        {//NSLog(@"re");
            [tem_com addObject:tem_re];
            NSString *add = [NSString stringWithFormat:@"retx_data_%@",key];
            //NSLog(@"Save retx");
            [self save:retx_data address:add key:key];
            add = nil;
            re_key = 1;
        }
        if(re_key == 1)
        {
            //NSLog(@"Retrx reorder");
            [self reorder:tem_nor retx:tem_re index:tem_nor.count key:key];
            [self recatch:[complete_data valueForKey:key] key:key];
            //NSLog(@"com:%@",complete_data);
            NSString *add = [NSString stringWithFormat:@"combine_data_%@",key];
            [self save:complete_data address:add key:key];
            //NSLog(@"redd");
            sort_key = 1;
        }
        
        if(sort_key == 0)
        {
            [complete_data setObject:tem_nor forKey:key];
            [self recatch:[complete_data valueForKey:key] key:key];
            //NSLog(@"com:%@",complete_data);
            NSString *add = [NSString stringWithFormat:@"combine_data_%@",key];
            [self save:complete_data address:add key:key];
        }
    }
}

- (void) recatch:(NSMutableArray*)complete_array key:(NSString*)key
{
    NSMutableArray *tem = [[NSMutableArray alloc] init];
    tem = complete_array;//NSLog(@"recatch tem.count:%lu",(unsigned long)tem.count);
    for(int i=1; i<tem.count; i++)
    {
        NSArray *ahead, *tail;
        int ahead_int, tail_int, difference;
        ahead = [tem objectAtIndex:i-1];
        tail = [tem objectAtIndex:i];
        ahead_int = [ahead[7] intValue];
        tail_int = [tail[7] intValue];
        difference = tail_int - ahead_int;
        if ( difference > 1 )
        {
            //NSLog(@"index: %d, difference: %d",i, difference);
            NSRange range = NSMakeRange(i, difference-1);//NSLog(@"range:%@",range);
            NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:range];
            [tem insertObjects:[self interpol:ahead tail_array:tail diff:difference index:i] atIndexes:indexes];
            //i = i + difference - 1;
        }
    }
    
    [complete_data setValue:tem forKey:key];
}

- (NSArray*) interpol:(NSArray*)ahead_array tail_array:(NSArray*)tail_array diff:(int) difference index:(int)index
{
    NSMutableArray *tem = [[NSMutableArray alloc] initWithCapacity:difference-1];
    NSArray *ans = [[NSArray alloc] init];
    float ahead_time = [ahead_array[0] floatValue];
    int ahead_ax = [ahead_array[1] intValue];
    int ahead_ay = [ahead_array[2] intValue];
    int ahead_az = [ahead_array[3] intValue];
    int ahead_gx = [ahead_array[4] intValue];
    int ahead_gy = [ahead_array[5] intValue];
    int ahead_gz = [ahead_array[6] intValue];
    int ahead_seq = [ahead_array[7] intValue];
    float tail_time = [tail_array[0] floatValue];
    int tail_ax = [tail_array[1] intValue];
    int tail_ay = [tail_array[2] intValue];
    int tail_az = [tail_array[3] intValue];
    int tail_gx = [tail_array[4] intValue];
    int tail_gy = [tail_array[5] intValue];
    int tail_gz = [tail_array[6] intValue];
    int tail_seq = [tail_array[7] intValue];
    float diff_time = (tail_time - ahead_time)/(difference-1);
    int diff_ax = (tail_ax - ahead_ax)/difference;
    int diff_ay = (tail_ay - ahead_ay)/difference;
    int diff_az = (tail_az - ahead_az)/difference;
    int diff_gx = (tail_gx - ahead_gx)/difference;
    int diff_gy = (tail_gy - ahead_gy)/difference;
    int diff_gz = (tail_gz - ahead_gz)/difference;
    int diff_seq = (tail_seq - ahead_seq)/difference;
    
    for(int i=1; i<difference; i++)
    {
        NSNumber *time = [NSNumber numberWithFloat:ahead_time+i*diff_time];
        NSNumber *ax = [NSNumber numberWithInt:ahead_ax+i*diff_ax];
        NSNumber *ay = [NSNumber numberWithInt:ahead_ay+i*diff_ay];
        NSNumber *az = [NSNumber numberWithInt:ahead_az+i*diff_az];
        NSNumber *gx = [NSNumber numberWithInt:ahead_gx+i*diff_gx];
        NSNumber *gy = [NSNumber numberWithInt:ahead_gy+i*diff_gy];
        NSNumber *gz = [NSNumber numberWithInt:ahead_gz+i*diff_gz];
        NSNumber *seq = [NSNumber numberWithInt:ahead_seq+i*diff_seq];
        NSArray *tem_for_tem = [[NSArray alloc] initWithObjects:time,ax,ay,az,gx,gy,gz,seq, nil];
        [tem addObject:tem_for_tem];
    }
    
    ans = tem;
    //NSLog(@"INterpol: %@",ans);
    return ans;
}

- (void) reorder:(NSMutableArray*)normal_array retx:(NSMutableArray*)retx_array index:(unsigned long)index key:(NSString*)key
{
    //NSLog(@"reorder");
    NSMutableArray *tem_normal;
    tem_normal = normal_array;
    //NSLog(@"array count: %lu",(unsigned long)retx_array.count);
    for(int i=0; i<retx_array.count; i++)
    {//NSLog(@"i:%d",i);
        //tem_normal = [retx_array objectAtIndex:i];
        for(int j=0; j<index; j++)
        {//NSLog(@"j:%d",j);
            //tem_retx = [retx_array objectAtIndex:j];
            if([retx_array objectAtIndex:i][7] < [normal_array objectAtIndex:j][7])
            {//NSLog(@"insert");
                [tem_normal insertObject:[retx_array objectAtIndex:i] atIndex:j];
                break;
            }
        }
    }
    [complete_data setValue:tem_normal forKey:key];
    //NSLog(@"Reorder done");
}

- (void) save:(NSMutableDictionary*)dic address:(NSString*)address key:(NSString*)key
{//NSLog(@"save");
    NSArray *tem = [[NSArray alloc] init];
    NSString* file_address = nil;
    NSFileHandle *handle;

        tem = [dic valueForKey:key];
        if(tem)
        {//NSLog(@"tem.count: %lu", (unsigned long)tem.count);
            NSArray *data = [[NSArray alloc] init];

                NSArray *pathsa = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [pathsa objectAtIndex:0];
                
                file_address = [NSString stringWithFormat:@"%@.csv", address];
                NSString *path = [documentsDirectory stringByAppendingPathComponent:file_address];
                
                // create if needed
                if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
                    [[NSData data] writeToFile:path atomically:YES];
                }
                
                // append
                handle = [NSFileHandle fileHandleForWritingAtPath:path];
            for(int j=0; j<tem.count; j++)
            {
                
                [handle truncateFileAtOffset:[handle seekToEndOfFile]];
                
                data = [tem objectAtIndex:j];
                
                NSString *outS = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@\r\n", data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7]];
                //NSLog(@"out%@",outS);
                //NSLog(@"Save to path: %@", path);
                [handle waitForDataInBackgroundAndNotify];
                [handle writeData:[outS dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            [handle closeFile];
            //NSLog(@"Save done address:%@, key: %@",address,key);

        }
}

@end