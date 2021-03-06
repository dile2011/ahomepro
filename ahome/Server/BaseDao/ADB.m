//
//  ADB.m
//  AtHomeApp
//
//  Created by dilei liu on 14-9-2.
//  Copyright (c) 2014年 ushome. All rights reserved.
//

#import "ADB.h"

#define DB_NAME @"AtHomeDB.sqlite"


static ADatabase *exsitDB = nil;

@implementation ADB


- (BOOL)initDatabase
{
	BOOL success;
    NSError *error;
	
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];

    NSFileManager *fm = [NSFileManager defaultManager];
	success = [fm fileExistsAtPath:writableDBPath];
	
	if(!success){ // 从工程目录拷贝文件到应用程序沙盒中
        writableDBPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:DB_NAME];
		success = [fm copyItemAtPath:writableDBPath toPath:writableDBPath error:&error];
		//if(!success)NSLog(@"error: %@", [error localizedDescription]);
		success = YES;
	}
    //NSLog(@"the path of local db file is: %@",writableDBPath);
	
	if(success){ // 如果存在
		exsitDB = [ADatabase databaseWithPath:writableDBPath];
		if ([exsitDB open]) {
			[exsitDB setShouldCacheStatements:YES];
		}else{
			NSLog(@"Failed to open database.");
			success = NO;
		}
	}
	
	return success;
}


- (void)closeDatabase {
	[exsitDB close];
}


- (ADatabase *)getDatabase
{
	if ([self initDatabase]){
		return exsitDB;
	}
	
	return NULL;
}

+ (ADatabase*)getDataBase {
    @synchronized(self)	{ // 避免多线程并发创建多个实例
		if (exsitDB) {
            return exsitDB;
        }
        [[ADB alloc]initDatabase];
	}
    
    return exsitDB;
}

- (void)dealloc
{
	[self closeDatabase];
	
	[db release];
    db = nil;
    
	[super dealloc];
}

@end
