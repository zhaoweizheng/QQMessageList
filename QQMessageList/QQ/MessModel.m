//
//  MessModel.m
//  QQMessageList
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import "MessModel.h"

@implementation MessModel

-(instancetype)initWithModel:(NSDictionary *)mess {

    if (self = [super init]) {
        self.imageName = mess[@"imageName"];
        self.desc      = mess[@"desc"];
        self.time      = mess[@"time"];
        self.person    = [mess[@"person"] boolValue];//转为Boll类型
    }
    return self;
}

+(instancetype)messModel:(NSDictionary *)mess {
    return [[self alloc] initWithModel:mess];
}

@end
