//
//  ModelFrame.h
//  QQMessageList
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MessModel;
@interface ModelFrame : NSObject
/** 时间的Frame */
@property (nonatomic, assign) CGRect    timeFrame;
/** 头像的Frame */
@property (nonatomic, assign) CGRect    headImageFrame;
/** 按钮(内容)的Frame */
@property (nonatomic, assign) CGRect    btnFrame;
/** 是否是自己发送的信息 */
@property (nonatomic, assign) BOOL      myself;
/** cell的高度 */
@property (nonatomic, assign) CGFloat   cellHeight;
/** 模型数据 */
@property (nonatomic, strong) MessModel *dataModel;

/** 通过模型数据计算出对应的Frame,并且返回出modelFrame自己这个对象 */
-(instancetype)initWithFrameModel:(MessModel *)modelData timeIsEqual:(BOOL)timeBool;
//同理
+(instancetype)modelFrame:(MessModel *)modelData timeIsEqual:(BOOL)timeBool;

@end
