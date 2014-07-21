//
//  socket.m
//  throughput
//
//  Created by Howard on 14/1/7.
//  Copyright (c) 2014年 EPL. All rights reserved.
//

#import "tableViewController.h"
#import "socket.h"
#import <Foundation/Foundation.h>


@implementation socket
@synthesize inputNameField;
@synthesize joinView;
@synthesize inputStream;
@synthesize outputStream;
NSMutableArray *message;
bool key = true;

//server ip 140.114.79.55


- (void) socketmain {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
	socket *c = [[socket alloc] init];
	
	c->host = @"http://140.114.79.55";
	c->port = 3000;
	
	[c setup];
	[c open];
	
	[pool drain];
}

CFReadStreamRef readStream;
CFWriteStreamRef writeStream;

NSInputStream *inputStream;
NSOutputStream *outputStream;

- (void)setup {
	NSURL *url = [NSURL URLWithString:host];
	
	NSLog(@"Setting up connection to %@ : %i", [url absoluteString], port);
	
	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)[url host], port, &readStream, &writeStream);
	
	if(!CFWriteStreamOpen(writeStream)) {
		NSLog(@"Error, writeStream not open");
		
		return;
	}
	[self open];
	
	NSLog(@"Status of outputStream: %i", [outputStream streamStatus]);
	
	return;
}

- (void)open {
	NSLog(@"Opening streams.");
	
	inputStream = (NSInputStream *)readStream;
	outputStream = (NSOutputStream *)writeStream;
	
	[inputStream retain];
	[outputStream retain];
	
	[inputStream setDelegate:self];
	[outputStream setDelegate:self];
	
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	[inputStream open];
	[outputStream open];
}

- (void)close {
	NSLog(@"Closing streams.");
	
	[inputStream close];
	[outputStream close];
	
	[inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	[inputStream setDelegate:nil];
	[outputStream setDelegate:nil];
	
	[inputStream release];
	[outputStream release];
	
	inputStream = nil;
	outputStream = nil;
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)event {
	NSLog(@"Stream triggered.");
	
	switch(event) {
		case NSStreamEventHasSpaceAvailable: {
			if(stream == outputStream) {
				NSLog(@"outputStream is ready.");
			}
			break;
		}
		case NSStreamEventHasBytesAvailable: {
			if(stream == inputStream) {
				NSLog(@"inputStream is ready.");
				
				uint8_t buf[1024];
				unsigned int len = 0;
				
				len = [inputStream read:buf maxLength:1024];
				
				if(len > 0) {
					NSMutableData* data=[[NSMutableData alloc] initWithLength:0];
					
					[data appendBytes: (const void *)buf length:len];
					
					NSString *s = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
					
					[self readIn:s];
					
					[data release];
				}
			}
			break;
		}
		default: {
			NSLog(@"Stream is sending an Event: %i", event);
			
			break;
		}
	}
}

- (void)readIn:(NSString *)s {
	NSLog(@"Reading in the following:");
	NSLog(@"%@", s);
}

- (void)writeOut:(NSString *)s {
	uint8_t *buf = (uint8_t *)[s UTF8String];
	
	[outputStream write:buf maxLength:strlen((char *)buf)];
	
	NSLog(@"Writing out the following:");
	NSLog(@"%@", s);
}

@end