//
//  SqiltBLL.h
//  SqliteTest
//
//  Created by 冯剑锋 on 16/3/30.
//  Copyright © 2016年 冯剑锋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqiltBLL : NSObject
/*!
 *  在数据库中创建一张表(切换正操作的表)
 *
 *  @param tableName 表单的名字
 *  @param dict @{@"key值":@"属性类型"}
 */
-(void)creatTableWithTableName:(NSString *) tableName AndDictionary:(NSDictionary *)dict;
/*!
 *  查询所有数据
 *
 *  @return 返回值放到数组里
 */
-(NSArray *)findAllData;
/*!
 *  想表中插入一条数据
 *
 *  @param model
 */
-(void)insertOneModel:(NSDictionary *)model;
/*!
 *  单利实例化方法
 *
 *  @return
 */
+(SqiltBLL *)shareSqiltBll;

@end
