//
//  ViewController.m
//  FMDBUpgradeDemo
//
//  Created by leo on 17/2/15.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "ViewController.h"
#import <FMDBMigrationManager/FMDBMigrationManager.h>
#import <FMDB/FMDB.h>
#import "Migration.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)handleBtn1Action:(id)sender {
    [self method1];
    //该方法的更新，需要把 文件夹中：  1_update.sql    2_update.sql  加入项目索引中，FMDBMigrationManager 会自动读取，并执行里面的对应sql语句。
}

- (IBAction)handleBtn2Action:(id)sender {
    [self method2];
}

- (void)method1 {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [path stringByAppendingPathComponent:@"database.db"];
    FMDBMigrationManager *manager = [FMDBMigrationManager managerWithDatabaseAtPath:dbPath migrationsBundle:[NSBundle mainBundle]];
    BOOL resultState = NO;
    NSError *error = nil;
    if (!manager.hasMigrationsTable) {
        resultState = [manager createMigrationsTable:&error];
    }
    resultState = [manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
}

- (void)method2 {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [path stringByAppendingPathComponent:@"database.db"];
    //需要保证 version 单调递增
    FMDBMigrationManager *manager = [FMDBMigrationManager managerWithDatabaseAtPath:dbPath migrationsBundle:[NSBundle mainBundle]];
    Migration *migration_1 = [[Migration alloc] initWithName:@"新增User_1表" version:1 executeUpdateArray:@[@"create table User_1 (name_1 text, age_1 integer)"]];
    Migration *migration_2 = [[Migration alloc] initWithName:@"User_1表新增email_1字段" version:2 executeUpdateArray:@[@"alter table User_1 add email_1 text"]];
    Migration *migration_3 = [[Migration alloc] initWithName:@"User_1表新增email_1字段" version:3 executeUpdateArray:@[@"insert into User_1 (name_1, age_1, email_1) values ('leo', 26, '273127393@qq.com')"]];
    [manager addMigration:migration_1];
    [manager addMigration:migration_2];
    [manager addMigration:migration_3];
    BOOL resultState = NO;
    NSError *error = nil;
    if (!manager.hasMigrationsTable) {
        resultState = [manager createMigrationsTable:&error];
    }
    resultState = [manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
    
}

@end
