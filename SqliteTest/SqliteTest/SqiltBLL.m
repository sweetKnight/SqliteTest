//
//  SqiltBLL.m
//  SqliteTest
//
//  Created by 冯剑锋 on 16/3/30.
//  Copyright © 2016年 冯剑锋. All rights reserved.
//

#import "SqiltBLL.h"
#import <sqlite3.h>

static SqiltBLL * bll = nil;
static NSString * const SqilteNameString = @"personinfo.sqlite";

@interface SqiltBLL(){
    sqlite3 * _sqlite;
    NSArray<NSString *> * _allKeyArray;
    NSString *tableNmaeString;
}
@end

@implementation SqiltBLL

+(SqiltBLL *)shareSqiltBll{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bll = [[self alloc]init];
        [bll creatSqiltList];
    });
    return bll;
}

-(void)creatTableWithTableName:(NSString *) tableName AndDictionary:(NSDictionary *)dict{
    tableNmaeString = tableName;
    NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,",tableName];

    _allKeyArray = [dict allKeys];
    for (int i = 0; i < _allKeyArray.count; i++) {
        NSString * string = @"";
        if (i != _allKeyArray.count - 1) {
            string = [NSString stringWithFormat:@" %@ %@,",_allKeyArray[i], [dict objectForKey:_allKeyArray[i]]];
        }else{
            string = [NSString stringWithFormat:@" %@ %@)",_allKeyArray[i], [dict objectForKey:_allKeyArray[i]]];
        }
        sqlCreateTable = [NSString stringWithFormat:@"%@%@",sqlCreateTable, string];
    }
    
    [self execSql:sqlCreateTable];
}

-(void)insertOneModel:(NSDictionary *)model{
    
    NSArray * allkey = [model allKeys];
    if (![allkey isEqualToArray:_allKeyArray]) {
        NSLog(@"要插入的数据格式错误");
        return;
    }
    NSString * sqlString = @"";
    NSString * keyString = [NSString stringWithFormat:@"INSERT INTO '%@' (",tableNmaeString];
    NSString * valueString = @" VALUES (";
    for (int i = 0; i < _allKeyArray.count; i++) {
        if (i != _allKeyArray.count - 1) {
            keyString = [NSString stringWithFormat:@"%@'%@', ",keyString,_allKeyArray[i]];
            valueString = [NSString stringWithFormat:@"%@'%@', ",valueString, [model objectForKey:_allKeyArray[i]]];
        }else{
            keyString = [NSString stringWithFormat:@"%@'%@')",keyString,_allKeyArray[i]];
            valueString = [NSString stringWithFormat:@"%@'%@')",valueString, [model objectForKey:_allKeyArray[i]]];
        }
        
    }
    sqlString = [NSString stringWithFormat:@"%@%@",keyString,valueString];
    [self execSql:sqlString];
}

-(NSArray *)findAllData{
    NSMutableArray * dataArray = [[NSMutableArray alloc]init];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@",tableNmaeString];
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(_sqlite, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:_allKeyArray.count];
            
            [_allKeyArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                char *valueString = (char*)sqlite3_column_text(statement, (int)idx+1);
                 NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:valueString];
                [dic setObject:nsAddressStr forKey:obj];
            }];
            [dataArray addObject:dic];
        }
    }
    sqlite3_close(_sqlite);
    return dataArray;
}

-(void)creatSqiltList{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:SqilteNameString];
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSLog(@"~~~~~~~~%@",database_path);
    });
    if (sqlite3_open([database_path UTF8String], &_sqlite) != SQLITE_OK) {
        sqlite3_close(_sqlite);
        NSLog(@"数据库打开失败");
    }
}

-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(_sqlite, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(_sqlite);
        NSLog(@"数据库操作数据失败!");
    }
}

@end
