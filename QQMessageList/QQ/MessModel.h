//
//  MessModel.h
//  QQMessageList
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessModel : NSObject

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) BOOL     person;

/** 将plist里的data转为model **/
-(instancetype)initWithModel:(NSDictionary *)mess;
//同理
+(instancetype)messModel:(NSDictionary *)mess;
@end
