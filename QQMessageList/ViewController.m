//
//  ViewController.m
//  QQMessageList
//
//  Created by apple on 16/5/29.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import "ViewController.h"
#import "messModel.h"
#import "modelFrame.h"
#import "CustomTableViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong)UITableView    *customTableView;
@property (nonatomic, strong)UITextField    *inputMess;
@property (nonatomic, strong)UIView         *bgView;
@property (nonatomic, strong)NSMutableArray *arrModelData;
@end

@implementation ViewController

-(NSMutableArray *)arrModelData {

    if (_arrModelData == nil) {
         _arrModelData=[NSMutableArray array];
    }
    return _arrModelData;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)  name:UIKeyboardWillHideNotification object:nil];
    //取消键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizersTapWithViewEidting)];
    [self.view addGestureRecognizer:tap];
   
    //创建输入框
    [self createTheInputBox];
    //创建主页面
    [self createTheMainUI];
    //数据
    [self messModelArr];
}

/**
 *  创建主页面
 */
- (void)createTheMainUI {
    [self.view setBackgroundColor:[UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:221.0/255.0f alpha:1.0f]];
    self.customTableView        = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.customTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bgView setBackgroundColor:[UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:221.0/255.0f alpha:1.0f]];
    _customTableView.delegate   = self;
    _customTableView.dataSource = self;
    [self.customTableView setBackgroundView:bgView];
    [self.customTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self.customTableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_customTableView];
    [self.customTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-50);
//        make.bottom.mas_equalTo(self.bgView.mas_top);
        make.top.equalTo(@0);
    }];
}
/**
 *  创建输入框
 */
- (void)createTheInputBox {
    
    self.bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor colorWithRed:1.000 green:0.756 blue:0.748 alpha:1.000];
    [self.view addSubview:_bgView];
    
    self.inputMess = [[UITextField alloc] init];
    self.inputMess.delegate = self;
    self.inputMess.backgroundColor = [UIColor whiteColor];
    self.inputMess.layer.cornerRadius = 5;
    self.inputMess.layer.masksToBounds = YES;
    [self.bgView addSubview:self.inputMess];
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView.backgroundColor = [UIColor clearColor];
    self.inputMess.leftView = leftView;
    self.inputMess.leftViewMode = UITextFieldViewModeAlways;
    self.inputMess.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.inputMess.delegate=self;//设置UITextField的代理
    self.inputMess.returnKeyType=UIReturnKeySend;//更改返回键的文字 (或者在sroryBoard中的,选中UITextField,对return key更改)
    self.inputMess.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"servicesS"] forState:UIControlStateNormal];
    [_bgView addSubview:button];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.inputMess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-50);
        make.bottom.mas_equalTo(-10);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inputMess).offset(5);
        make.left.mas_equalTo(self.inputMess.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
}
/**
 *  数据
 */
-(void)messModelArr{
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"dataPlist.plist" ofType:nil];//得到Plist文件里面的数据
    NSArray  *arrData = [NSArray arrayWithContentsOfFile:strPath];
    for (NSDictionary *dicData in arrData) {
        MessModel *model = [[MessModel alloc] initWithModel:dicData];
        BOOL isEquel;
        if (self.arrModelData) {
            isEquel = [self timeIsEqual:model.time];//判断上一个模型数据里面的时间是否和现在的时间相等
        }
        ModelFrame *frameModel = [[ModelFrame alloc] initWithFrameModel:model timeIsEqual:isEquel];
        [self.arrModelData addObject:frameModel];//添加Frame的模型到数组里面
    }
    
    [_customTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrModelData.count-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark  -TableView的DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrModelData.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModelFrame *frameModel=self.arrModelData[indexPath.row];
    return frameModel.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *strId=@"cellId";
    CustomTableViewCell *customCell=[tableView dequeueReusableCellWithIdentifier:strId];
    if (customCell==nil) {
        customCell=[[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strId];
    }
    [customCell setBackgroundColor:[UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:221.0/255.0f alpha:1.0f]];
     customCell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.arrModelData.count != 0) {
        customCell.frameModel=self.arrModelData[indexPath.row];
    }
    return customCell;
}

#pragma mark ------ 手势 ---------
- (void)gestureRecognizersTapWithViewEidting {
    [self.view endEditing:YES];
}
#pragma mark 滚动TableView去除键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.inputMess resignFirstResponder];
}
#pragma mark ------ 通知 ---------
-(void)keyBoardWillShow:(NSNotification*)notification {
    [self dealKeyboardFrame:notification];
}

-(void)keyboardWillBeHidden:(NSNotification *)notification {
      [self dealKeyboardFrame:notification];
}
#pragma mark 处理键盘的位置
-(void)dealKeyboardFrame:(NSNotification *)changeMess{
    NSDictionary *dicMess=changeMess.userInfo;//键盘改变的所有信息
    CGFloat changeTime=[dicMess[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];//通过userInfo 这个字典得到对得到相应的信息//0.25秒后消失键盘
    CGFloat keyboardMoveY=[dicMess[UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y-[UIScreen mainScreen].bounds.size.height;//键盘Y值的改变(字典里面的键UIKeyboardFrameEndUserInfoKey对应的值-屏幕自己的高度)
    [UIView animateWithDuration:changeTime animations:^{ //0.25秒之后改变tableView和bgView的Y轴
        self.customTableView.transform=CGAffineTransformMakeTranslation(0, keyboardMoveY);
        self.bgView.transform=CGAffineTransformMakeTranslation(0, keyboardMoveY);
    }];
    NSIndexPath *path=[NSIndexPath indexPathForItem:self.arrModelData.count-1 inSection:0];
    [self.customTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];//将tableView的行滚到最下面的一行
}

#pragma mark TextField的Delegate send后的操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{  //
    [self sendMess:textField.text]; //发送信息
    return YES;
}

- (void)sendAction:(UIButton *)sender {
    [self sendMess:self.inputMess.text]; //发送信息
}

#pragma mark 发送消息,刷新数据
-(void)sendMess:(NSString *)messValues{
    //添加一个数据模型(并且刷新表)
    //获取当前的时间
    NSDate *nowdate=[NSDate date];
    NSDateFormatter *forMatter=[[NSDateFormatter alloc]init];
    forMatter.dateFormat=@"HH:mm"; //小时和分钟
    NSString *nowTime=[forMatter stringFromDate:nowdate];
    NSMutableDictionary *dicValues=[NSMutableDictionary dictionary];
    dicValues[@"imageName"]=@"girl";
    dicValues[@"desc"]=messValues;
    dicValues[@"time"]=nowTime; //当前的时间
    dicValues[@"person"]=[NSNumber numberWithBool:0]; //转为Bool类型
    MessModel *mess=[[MessModel alloc]initWithModel:dicValues];
    ModelFrame *frameModel=[ModelFrame modelFrame:mess timeIsEqual:[self timeIsEqual:nowTime]]; //判断前后时候是否一致
    [self.arrModelData addObject:frameModel];
    [self.customTableView reloadData];

    self.inputMess.text=nil;
    
    //自动回复就是再次添加一个frame模型
    NSArray *arrayAutoData=@[@"蒸桑拿蒸馒头不争名利，弹吉它弹棉花不谈感情",@"女人因为成熟而沧桑，男人因为沧桑而成熟",@"男人善于花言巧语，女人喜欢花前月下",@"笨男人要结婚，笨女人要减肥",@"爱与恨都是寂寞的空气,哭与笑表达同样的意义",@"男人的痛苦从结婚开始，女人的痛苦从认识男人开始",@"女人喜欢的男人越成熟越好，男人喜欢的女孩越单纯越好。",@"做男人无能会使女人寄希望于未来，做女人失败会使男人寄思念于过去",@"我很优秀的，一个优秀的男人，不需要华丽的外表，不需要有渊博的知识，不需要有沉重的钱袋",@"世间纷繁万般无奈，心头只求片刻安宁"];
    //添加自动回复的
    int num= arc4random() %(arrayAutoData.count); //获取数组中的随机数(数组的下标)
    NSMutableDictionary *dicAuto=[NSMutableDictionary dictionary];
    dicAuto[@"imageName"]=@"boy";
    dicAuto[@"desc"]=[arrayAutoData objectAtIndex:num];
    dicAuto[@"time"]=nowTime;
    dicAuto[@"person"]=[NSNumber numberWithBool:1]; //转为Bool类型
    MessModel *messAuto=[[MessModel alloc]initWithModel:dicAuto];
    ModelFrame *frameModelAuto=[ModelFrame modelFrame:messAuto timeIsEqual:[self timeIsEqual:nowTime]];//判断前后时候是否一致
    [self.arrModelData addObject:frameModelAuto];
    [self.customTableView reloadData];
    
    NSIndexPath *path=[NSIndexPath indexPathForItem:self.arrModelData.count-1 inSection:0];
    [self.customTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];

}

#pragma mark 判断前后时间是否一致
-(BOOL)timeIsEqual:(NSString *)comStrTime{
    ModelFrame *frame=[self.arrModelData lastObject];//与最后一个元素相比
    NSString *strTime=frame.dataModel.time; //frame模型里面的NSString时间
    if ([strTime isEqualToString:comStrTime]) { //比较2个时间是否相等
        return YES;
    }
    return NO;
}

@end
