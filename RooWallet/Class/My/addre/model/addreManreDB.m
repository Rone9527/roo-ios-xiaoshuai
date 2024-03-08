//
//  addreManreDB.m
//  RooWallet
//
//  Created by mac on 2021/6/26.
//

#import "addreManreDB.h"

@implementation addreManreDB
+ (FMDatabase *)homeInfoDB {
    //1.文件路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
    NSString *filePath = [doc stringByAppendingPathComponent:@"addreInfo.sqlite"];
//    NSLog(@"s--%@",filePath);
    //2， 获取数据库
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    return db;
}

+ (void)creatsHomeInfoDB {
    
    FMDatabase *db = [addreManreDB homeInfoDB];
    if ([db open]) {
        //ChinaCode name addreStr subStr creatimer
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS addreInfo ( ChinaCode text, name text ,creatimer text ,addreStr text , subStr text)"];
        if (result) {
            NSLog(@"create addretable success");
        }
        [db close];
    }
}

+ (void)saveInfoModel:(addreModel *)model {
    
    FMDatabase *db = [addreManreDB homeInfoDB];
    if (![db open]) {
        NSLog(@"database does not open.");
        return;
    }
    //ChinaCode name addreStr subStr creatimer
//
    BOOL result = [db executeUpdate:@"INSERT INTO addreInfo (ChinaCode,name,addreStr,subStr,creatimer) VALUES (?,?,?,?,?);", model.ChinaCode,model.name,model.addreStr,model.subStr,model.creatimer];
    if (result) {
        NSLog(@"add user success");
    }
    [db close];
}

+ (NSMutableArray *)getUserInfoArray {
    NSMutableArray *reslut = [NSMutableArray array];
    FMDatabase *db = [addreManreDB homeInfoDB];
    if ([db open]) {
        FMResultSet *reslutSet = [db executeQuery:@"SELECT * FROM addreInfo"];
        while ([reslutSet next]) {
            NSDictionary * dict = [reslutSet resultDictionary];
            
            addreModel *model = [addreModel mj_objectWithKeyValues:dict];
            
            if (reslut.count == 0) {
                [reslut addObject:model];
            } else {
                [reslut insertObject:model atIndex:0];
            }
            
        }
        [db close];
    }
    return  reslut;
}
+ (void)removeInfoModel:(addreModel *)model {
    
    FMDatabase *db = [addreManreDB homeInfoDB];
    if (![db open]) {
        NSLog(@"database does not open.");
        return;
    }
    NSString *removeModel = [NSString stringWithFormat:@"DELETE FROM addreInfo where creatimer = '%@'",model.creatimer];
    [db executeUpdate:removeModel];
    [db close];
}

/// 更新（修改）用户
+ (void)updateUser:(addreModel *)model {
    FMDatabase *db = [addreManreDB homeInfoDB];
    if (![db open]) {
        NSLog(@"database does not open.");
        return;
    }
    //ChinaCode name addreStr subStr creatimer
    NSString *execSql = [NSString stringWithFormat:@"UPDATE addreInfo SET ChinaCode = '%@' ,name ='%@' ,addreStr='%@',subStr='%@'  WHERE creatimer = '%@'", model.ChinaCode,model.name,model.addreStr,model.subStr,model.creatimer];
    BOOL result = [db executeUpdate:execSql];
    if (result) {
        NSLog(@"update user success");
    }
    [db close];
}
/// 删除所有用户
+ (void)deleteAllUser {
    FMDatabase *db = [addreManreDB homeInfoDB];
    if (![db open]) {
        NSLog(@"database does not open.");
        return;
    }
    NSString *execSql = [NSString stringWithFormat:@"DELETE FROM addreInfo"];
    BOOL result = [db executeUpdate:execSql];
    if (result) {
        NSLog(@"delete all user success");
    }
    [db close];
}
@end
