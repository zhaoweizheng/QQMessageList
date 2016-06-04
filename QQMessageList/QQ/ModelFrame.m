//
//  ModelFrame.m
//  QQMessageList
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import "ModelFrame.h"
#import "MessModel.h"
#define timeFont    [UIFont systemFontOfSize:11.0]//时间的字体大小
#define contentFont [UIFont systemFontOfSize:13.0]//聊天消息字体的大小
#define distance    8                             //边距
#define imageH      46                            //头像的宽高
@implementation ModelFrame

-(instancetype)initWithFrameModel:(MessModel *)modelData timeIsEqual:(BOOL)timeBool {
    if (self = [super init]) {
        self.dataModel = modelData;
        CGSize timeSize = [modelData.time sizeWithAttributes:@{NSFontAttributeName:timeFont}];//通过时间NSString计算出宽度
        if (!timeBool) {//前后时间不相等
            self.timeFrame = CGRectMake(0, 0, SCREEN_WIDTH, timeSize.height);//显示时间的Frame
        } else {
            self.timeFrame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        }
        
        //发送内容的Frame
        CGRect btnRect = [modelData.desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.6, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:contentFont}
                                                      context:nil];

        if (modelData.person) {//如果是男的发送的话,头像就在右边,文字也在左边,否则头像就在左边,文字也在右边
            self.headImageFrame = CGRectMake(SCREEN_WIDTH-distance-imageH, CGRectGetMaxY(self.timeFrame)+distance, imageH, imageH);
            self.btnFrame       = CGRectMake(SCREEN_WIDTH-distance*2-imageH-btnRect.size.width- 20*2, CGRectGetMaxY(self.timeFrame)+distance, btnRect.size.width+20*2, btnRect.size.height+20*2);//按钮内容的Frame(因为在CustomTableViewCell 里面设置了btnFrame里面文字的titleEdgeInsets边距都为20,所以,宽和高都要+20*2,X-20*2)
        } else {
            self.headImageFrame = CGRectMake(distance, CGRectGetMaxY(self.timeFrame)+distance,imageH, imageH);
            self.btnFrame       = CGRectMake(distance+imageH+distance, CGRectGetMaxY(self.timeFrame)+distance, btnRect.size.width+20*2, btnRect.size.height+20*2);
        }
        
        self.myself     = modelData.person;//是否是自己发的信息
        CGFloat cellH   = MAX(CGRectGetMaxY(self.btnFrame), CGRectGetMaxY(self.headImageFrame));//比较输入的内容和头像的Y值哪个大
        self.cellHeight = cellH+distance;//返回Cell的高度
    }
    return self;
}

+(instancetype)modelFrame:(MessModel *)modelData timeIsEqual:(BOOL)timeBool {
    return [[self alloc] initWithFrameModel:modelData timeIsEqual:timeBool];
}

@end
