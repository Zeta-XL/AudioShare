//
//  DataBaseHandle.m
//  SQLite3_2
//
//  Created by lanou3g on 15/7/14.
//  Copyright (c) 2015年 zhaoxinlei. All rights reserved.
//

#import "DataBaseHandle.h"
#import <sqlite3.h>
static DataBaseHandle *dataBase = nil;

@implementation DataBaseHandle
+ (instancetype)shareDataBase
{
    if (dataBase == nil) {
        dataBase = [[DataBaseHandle alloc] init];
    }
    return dataBase;
}

// 根据枚举值获取路径
- (NSString *)getPathOf:(enumPaths) pathParas
{
    switch (pathParas) {
        case Document:
            return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            break;
        case Cache:
            return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            break;
        case Temp:
            return NSTemporaryDirectory();
            break;
        default:
            return nil;
            break;
    }
}

static sqlite3 *db;

// 打开数据库
- (void)openDBWithName:(NSString *)dbName atPath:(NSString *)path
{
    if (db != nil) {
        NSLog(@"数据库已打开");
        return;
    }
    NSString *dbPath = [path stringByAppendingPathComponent:dbName];
    // 打开数据库
    int result = sqlite3_open(dbPath.UTF8String, &db);
    if (result == SQLITE_OK) {
        NSLog(@"数据库%@打开成功", dbName);
    }else {
        NSLog(@"数据库%@打开失败",dbName);
        perror("数据库打开失败");
    }
    
    
}

// 关闭数据库;
- (void)closeDB
{
    if (db == nil) {
        NSLog(@"数据已关闭");
    }
    
    int result = sqlite3_close(db);
    if (result == SQLITE_OK) {
        NSLog(@"数据库关闭成功");
    }else{
        NSLog(@"数据库关闭失败");
        perror("失败:");
    }
    db = nil;
}

// 建表
- (void)createTableWithName:(NSString *)tableName paramNames:(NSArray *)nameArray paramTypes:(NSArray *)TypeArray;
{
    if (nameArray.count != TypeArray.count) {
        NSLog(@"参数不匹配, 建表失败");
        
        return;
    }
    //SQL语句
    NSMutableString *createTableSQL = [NSMutableString stringWithFormat:@"create table if not exists %@ (sid integer primary key autoincrement not null", tableName];
    for (NSInteger i = 0; i < nameArray.count; i++) {
        [createTableSQL appendFormat:@",%@ %@", nameArray[i], TypeArray[i]];
    }
    [createTableSQL appendString:@")"];
    
    // 执行SQL语句
    int result = sqlite3_exec(db, createTableSQL.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"添加表成功");
    }else {
        NSLog(@"添加表失败");
    }
}

// 创建表 自定义primary key
- (void)createTableWithName:(NSString *)tableName paramNames:(NSArray *)nameArray paramTypes:(NSArray *)TypeArray setPrimaryKey:(BOOL) option
{
    if (nameArray.count != TypeArray.count) {
        NSLog(@"参数不匹配, 建表失败");
        return;
    }
    
    NSString *createTableSQL = nil;
    if (option) {
        // 存放参数名和类型的字符串
        NSMutableArray *strArray = [NSMutableArray array];
        for (NSInteger i = 1; i < nameArray.count; i++) {
            NSString *subStr = [NSString stringWithFormat:@"%@ %@", nameArray[i], TypeArray[i]];
            [strArray addObject:subStr];
        }
        NSString *formatStr = [strArray componentsJoinedByString:@", "];
        
        createTableSQL = [NSString stringWithFormat:@"create table if not exists %@ (%@ %@ primary key not null, %@)", tableName, nameArray[0], TypeArray[0], formatStr];
        
    } else {
        
        // 存放参数名和类型的字符串
        NSMutableArray *strArray = [NSMutableArray array];
        for (NSInteger i = 0; i < nameArray.count; i++) {
            NSString *subStr = [NSString stringWithFormat:@"%@ %@", nameArray[i], TypeArray[i]];
            [strArray addObject:subStr];
        }
        NSString *formatStr = [strArray componentsJoinedByString:@", "];
        
        createTableSQL = [NSString stringWithFormat:@"create table if not exists %@ (sid integer primary key autoincrement not null, %@)", tableName, formatStr];
    }
    // 执行SQL语句
    int result = sqlite3_exec(db, createTableSQL.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"添加表成功");
    }else {
        NSLog(@"添加表失败");
    }
    
    
    
}

// 删除表
- (void)dropTableWithName:(NSString *)tableName
{
    NSString *dropTableSQL = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    // 执行SQL语句
    int result = sqlite3_exec(db, dropTableSQL.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"删除表成功");
    }else {
        NSLog(@"删除表失败");
    }
    
}





// 插入数据任意
- (BOOL)insertIntoTable:(NSString *)tableName
              paramKeys:(NSArray *)keys
             withValues:(NSArray *)values;
{
    // SQL语句
    NSString *keyString = [keys componentsJoinedByString:@", "];
    
    
    NSString *valueString = [values componentsJoinedByString:@"', '"];
    valueString = [NSString stringWithFormat:@"'%@'", valueString];
    
    
    NSString *insertSQL = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)", tableName, keyString, valueString];
    NSLog(@"%@", insertSQL);
    int result = sqlite3_exec(db, insertSQL.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"插入成功");
        return YES;
    }else{
        NSLog(@"插入失败");
        return NO;
    }

}



// 插入数据
- (BOOL)insertIntoTable:(NSString *)tableName
              paramKeys:(NSArray *)keys
              WithModel:(id)model

{
    // SQL语句
    NSString *keyString = [keys componentsJoinedByString:@", "];
    
    NSMutableArray *userPropertys = [NSMutableArray array];
    for (NSString *prop in keys) {
        id obj = [model valueForKey:prop];
        [userPropertys addObject:obj];
    }
    NSString *valueString = [userPropertys componentsJoinedByString:@"', '"];
    valueString = [NSString stringWithFormat:@"'%@'", valueString];
    
    
    NSString *insertSQL = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)", tableName, keyString, valueString];
    
    int result = sqlite3_exec(db, insertSQL.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"插入成功");
        return YES;
    }else{
        NSLog(@"插入失败");
        return NO;
    }
    
}

// 删
- (void)deletefromTable:(NSString *)tableName
                withKey:(NSString *)key
                  value:(NSString *)value
{
    // SQL语句
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", tableName, key, value];
    
    // 执行
    int result = sqlite3_exec(db, deleteSQL.UTF8String , NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"删除成功");
    }else {
        NSLog(@"删除失败");
    }
    
}

// 根据Primary key改
- (void)updateTable:(NSString *)tableName
         changeDict:(NSDictionary *)dict
       atPrimaryKey:(NSString *)primaryKey
    primaryKeyValue:(NSString *)keyValue
{
    // SQL语句
    
    NSMutableArray *changeArray = [NSMutableArray array];
    for (NSString *key in [dict allKeys]) {
        NSString *tmpStr = [NSString stringWithFormat:@"%@ = '%@'", key, dict[key]];
        [changeArray addObject:tmpStr];
    }
    
    NSString *changeStr = [changeArray componentsJoinedByString:@", "];
    
    NSString *updateSQL = [NSString stringWithFormat:@"update %@ set %@ where %@ = '%@'", tableName, changeStr,primaryKey, keyValue];
    
    // 执行
    int result = sqlite3_exec(db, updateSQL.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"数据更改成功");
        
    }else {
        NSLog(@"数据更新失败");
    }
}

// 全查
- (NSArray *)selectAllFromTable:(NSString *)tableName modelProperty:(NSArray *)propertes sidOption:(BOOL)option
{
    NSMutableArray *modelArray = nil;
    
    // SQL
    NSString *selectALLSQL = [NSString stringWithFormat:@"select * from %@", tableName];
    
    // 伴随指针
    sqlite3_stmt *stmt = NULL;
    
    // 预执行
    int result = sqlite3_prepare_v2(db, selectALLSQL.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        //
        modelArray = [NSMutableArray array];
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            AlbumModel *am = [[AlbumModel alloc] init];
            if (option) {
                
                NSInteger sid = sqlite3_column_int(stmt, 0);
                for (int i = 0; i < propertes.count; i++) {
                    NSString *proString = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, i+1)];
                    [am setValue: proString forKey:propertes[i]];
                }
                NSMutableArray *tempArr = [NSMutableArray arrayWithArray:@[@(sid), am]];
                [modelArray addObject:tempArr];
                
            }else {
            
                for (int i = 0; i < propertes.count; i++) {
                    NSString *proString = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, i)];
                    [am setValue: proString forKey:propertes[i]];
                }
            
                [modelArray addObject:am];
            }
        }
        
    }
    
    sqlite3_finalize(stmt);
    
    return modelArray;
}

// Primary条件查
- (NSArray *)selectFromTable:(NSString *)tableName withKey:(NSString *) key pairValue:(NSString *)value modelProperty:(NSArray *)propertes
{
    NSMutableArray *modelArray = nil;
    
    // SQL语句
    NSString *selectSQL = [NSString stringWithFormat: @"select * from %@ where %@ = ?", tableName, key];
    
    // 创建伴随指针
    sqlite3_stmt *stmt = nil;
    
    // 预执行
    int result = sqlite3_prepare_v2(db, selectSQL.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        // 初始化数组
        modelArray = [NSMutableArray array];
      
        // 绑定参数
        sqlite3_bind_text(stmt, 1, value.UTF8String, -1, NULL);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            AlbumModel *am = [[AlbumModel alloc] init];
            for (int i = 0; i < propertes.count; i++) {
                NSString *proString = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, i)];
                [am setValue: proString forKey:propertes[i]];
            }
            
            [modelArray addObject:am];
        }
        
        if (modelArray.count ==0) {
            NSLog(@"没查到");
            sqlite3_finalize(stmt);
            return nil;
        }
        
    }else {
        NSLog(@"查找无结果");
    }
    
    // 关闭伴随指针
    sqlite3_finalize(stmt);
    
    
    return modelArray;
}

// 多条件查询
- (NSArray *)selectFromTable:(NSString *)tableName
               withQueryDict:(NSDictionary *)dict
               modelProperty:(NSArray *)propertes
{
    NSMutableArray *modelArray = nil;
    
    // SQL语句
    NSMutableArray *subStrArray = [NSMutableArray array];
    for (NSString *key in dict.allKeys) {
        NSString *subStr = [NSString stringWithFormat:@" %@ = '%@' ", key, dict[key]];
        [subStrArray addObject:subStr];
    }
    NSString *conditions = [subStrArray componentsJoinedByString:@"and"];
    NSString *selectSQL = [NSString stringWithFormat: @"select * from %@ where %@", tableName, conditions];
    NSLog(@"%@", selectSQL);
    // 创建伴随指针
    sqlite3_stmt *stmt = nil;
    
    // 预执行
    int result = sqlite3_prepare_v2(db, selectSQL.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        // 初始化数组
        modelArray = [NSMutableArray array];
        
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            AlbumModel *am = [[AlbumModel alloc] init];
            for (int i = 0; i < propertes.count; i++) {
                NSString *proString = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, i)];
                [am setValue: proString forKey:propertes[i]];
            }
            
            [modelArray addObject:am];
        }
        
        if (modelArray.count ==0) {
            NSLog(@"没查到");
            // 关闭伴随指针
            sqlite3_finalize(stmt);
            return nil;
        }
        
    }else {
        NSLog(@"查找失败");
    }
    
    // 关闭伴随指针
    sqlite3_finalize(stmt);
                           
    return modelArray;
    
}




@end
