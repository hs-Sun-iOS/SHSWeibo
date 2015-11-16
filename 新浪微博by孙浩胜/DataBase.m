//
//  DataBase.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/29.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "DataBase.h"
#import "FMDB.h"

static FMDatabaseQueue *_queue;
@implementation DataBase

+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"weiboCache.sqlite"];
    NSLog(@"path = %@",path);
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    [_queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSLog(@"数据库打开成功");
          BOOL flag = [db executeUpdate:@"create table if not exists t_weibo (id integer primary key autoincrement,json blob,idstr text,access_token text);"];
            if (flag) {
                NSLog(@"建表成功");
            } else
                NSLog(@"建表失败");
        }
        else
            NSLog(@"数据库打开失败");
    }];
}

+ (void)addJsonDataArrayToDataBase:(NSArray *)dataArr
{
    for (NSDictionary *dict in dataArr) {
        [self addJsonDataToDataBase:dict];
    }
}


+ (void)addJsonDataToDataBase:(NSDictionary *)dict
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    NSString *access_token = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL flag = [db executeUpdate:@"insert into t_weibo (json,idstr,access_token) values (?,?,?)",data,dict[@"idstr"],access_token];
        if (!flag) {
           NSLog(@"保存数据失败");
        }
        
    }];
}

+ (NSArray *)getJsonDataArrayFromDataBaseWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *dataArr = [NSMutableArray array];
    NSString *access_token = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        if (parameters[@"since_id"]) {
            rs = [db executeQuery:@"select json from t_weibo where idstr>? and access_token=? order by idstr desc limit 0 ,?;",parameters[@"since_id"],access_token,parameters[@"count"]];
        } else if (parameters[@"max_id"])
            rs = [db executeQuery:@"select json from t_weibo where idstr<? and access_token=? order by idstr desc limit 0 ,?;",parameters[@"max_id"],access_token,parameters[@"count"]];
        else
            rs = [db executeQuery:@"select json from t_weibo where access_token=? order by idstr desc limit 0 ,?;",access_token,parameters[@"count"]];
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"json"];
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [dataArr addObject:dict];
        }
    }];
    
    return dataArr;
}
@end
