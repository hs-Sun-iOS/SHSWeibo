//
//  DataBase.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/29.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBase : NSObject

+ (void) addJsonDataArrayToDataBase:(NSArray *)dataArr;

+ (NSArray *) getJsonDataArrayFromDataBaseWithParameters:(NSDictionary *)parameters;
@end
