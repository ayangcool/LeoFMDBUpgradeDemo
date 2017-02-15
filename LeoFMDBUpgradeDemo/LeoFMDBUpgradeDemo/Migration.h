//
//  Migration.h
//  FMDBUpgradeDemo
//
//  Created by leo on 17/2/15.
//  Copyright © 2017年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDBMigrationManager/FMDBMigrationManager.h>

@interface Migration : NSObject <FMDBMigrating>

//protocl
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, assign) uint64_t version;

- (BOOL)migrateDatabase:(FMDatabase *)database error:(out NSError *__autoreleasing *)error;

//custom
- (instancetype)initWithName:(NSString *)name version:(uint64_t)version executeUpdateArray:(NSArray *)updateArray;

@end
