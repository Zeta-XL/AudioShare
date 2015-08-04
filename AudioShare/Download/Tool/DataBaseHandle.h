//
//  DataBaseHandle.h
//  SQLite3_Tool 
//
//  Created by lanou3g on 15/7/14.
//  Copyright (c) 2015年 zhaoxinlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumModel.h"

#define kDBName @"userData.sqlite"
#define kFavorateTableName @"favorateTable"
#define kHistoryTableName @"historyTable"

typedef enum paths{
    Document = 0,
    Cache,
    Temp
}enumPaths;

@interface DataBaseHandle : NSObject
+ (instancetype)shareDataBase;

// 根据枚举值获取路径
- (NSString *)getPathOf:(enumPaths) pathParas;

// 打开数据库
- (void)openDBWithName:(NSString *)dbName atPath:(NSString *)path;

// 关闭数据库;
- (void)closeDB;

// 创建表
- (void)createTableWithName:(NSString *)tableName paramNames:(NSArray *)nameArray paramTypes:(NSArray *)TypeArray;


// 创建表 自定义primary key
- (void)createTableWithName:(NSString *)tableName paramNames:(NSArray *)nameArray paramTypes:(NSArray *)TypeArray setPrimaryKey:(BOOL) option;




// 删除表
- (void)dropTableWithName:(NSString *)tableName;


// 插入数据(专辑)
- (BOOL)insertIntoTable:(NSString *)tableName
              paramKeys:(NSArray *)keys
              WithModel:(id) model;

// 插入数据任意
- (BOOL)insertIntoTable:(NSString *)tableName
              paramKeys:(NSArray *)keys
             withValues:(NSArray *)values;


// 删除
- (void)deletefromTable:(NSString *)tableName
                withKey:(NSString *)key
                  value:(NSString *)value;

// 改
- (void)updateTable:(NSString *)tableName
         changeDict:(NSDictionary *)dict
       atPrimaryKey:(NSString *)primaryKey
    primaryKeyValue:(NSString *)keyValue;


// 全查
- (NSArray *)selectAllFromTable:(NSString *)tableName modelProperty:(NSArray *)propertes sidOption:(BOOL)option;


// 条件查
- (NSArray *)selectFromTable:(NSString *)tableName withKey:(NSString *) key pairValue:(NSString *)value modelProperty:(NSArray *)propertes;

// 多条件查询
- (NSArray *)selectFromTable:(NSString *)tableName
               withQueryDict:(NSDictionary *)dict
               modelProperty:(NSArray *)propertes;





@end
