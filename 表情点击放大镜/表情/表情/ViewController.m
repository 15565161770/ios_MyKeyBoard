//
//  ViewController.m
//  表情
//
//  Created by Apple on 16/12/12.
//  Copyright © 2016年 仝兴伟. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+Extension.h"
#import "UIView+WLFrame.h"
#import "UIView+Extension.h"
#import "HMStatusToolbar.h"

#import "HMComposeToolbar.h"
#import "HMEmotionKeyboard.h"
#import "HMEmotion.h"
@interface ViewController ()<HMStatusToolbarDelegate, UITextViewDelegate, HMComposeToolbarDelegate>
@property (nonatomic, strong)UITextView *textViews;
@property (nonatomic, strong)HMComposeToolbar *toolbar;

/**
 *  是否正在切换键盘
 */
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;
@property (nonatomic, strong)HMEmotionKeyboard *keyboard;
@end

@implementation ViewController

/**
 *  自定义键盘  懒加载
 */
-(HMEmotionKeyboard *)keyboard {
    if (!_keyboard) {
        self.keyboard = [HMEmotionKeyboard keyboard];
        self.keyboard.width = self.view.width;
        self.keyboard.height = 216;
    }
    return _keyboard;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textViews = [[UITextView alloc]init];
    self.textViews.frame = CGRectMake((self.view.bounds.size.width - 300) / 2, 100, 300, 100);
    self.textViews.backgroundColor = [UIColor redColor];
    self.textViews.alwaysBounceVertical = YES; // 成为第一相应这  能叫出键盘 设置代理就是为了拖动textview的时候键盘退出
    self.textViews.delegate = self;
    [self.view addSubview:self.textViews];
    
    // 监听键盘的状态，根据键盘状态触发不同的方法
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //  添加toolbar
    [self addToolBar];
    
    // 监听表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
}

- (void)addToolBar {
    HMComposeToolbar *toolbar = [[HMComposeToolbar alloc]init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}

#pragma mark -- 键盘处理
/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.isChangingKeyboard) {
        self.changingKeyboard = NO;
        return;
    }
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;
    }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
    }];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /**
     *  让键盘成为第一相应者
     */
    [self.textViews becomeFirstResponder];
    
}

#pragma mark --  UITextView代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"开始拖拽");
    [self.view endEditing:YES];
}
#pragma mark -- toolBar 代理方法
- (void)composeTool:(HMComposeToolbar *)toolbar didClickedButton:(HMComposeToolbarButtonTypes)buttonType{
    switch (buttonType) {
        case HMComposeToolbarButtonTypeEmotion:
            [self openEmotion];
            break;
            
        default:
            break;
    }
}


#pragma mark -- 表情
- (void)openEmotion {
    NSLog(@"调用表情");
    
    // 正在切换键盘
    self.changingKeyboard = YES;
    
    if (self.textViews.inputView) { // 先判断键盘是否为空，如果是不为空说明是自定义键盘
        self.textViews.inputView = nil;
        
        // 显示表情图片
        self.toolbar.showEmotionButton = YES;
    } else { // 如果为空说明是系统自大键盘
        self.textViews.inputView = self.keyboard;
        
        // 不显示表情图片
        self.toolbar.showEmotionButton = NO;
    }
    
    // 切换键盘前先关闭键盘   然后再打开键盘
    [self.textViews resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 打开键盘
        [self.textViews becomeFirstResponder];
    });
}

/**
 *  当表情选中的时候调用
 *
 *  @param note 里面包含了选中的表情
 */
- (void)emotionDidSelected:(NSNotification *)note
{
    HMEmotion *emotion = note.userInfo[HMSelectedEmotion];
    NSLog(@"=%@ =%@", emotion.chs, emotion.emoji);
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
