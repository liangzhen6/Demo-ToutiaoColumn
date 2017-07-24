//
//  ViewController.m
//  NewsDemo
//
//  Created by shenzhenshihua on 2017/7/13.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import "ColumnBackView.h"
#import "ColumnModel.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property(nonatomic,strong)ColumnBackView *backView;

@property(nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor lightTextColor];

    ColumnBackView * back = [ColumnBackView columnBackView];
    back.dataSource = self.dataSource;
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - 60;
    back.frame = CGRectMake(0, 80 - height, frame.size.width, height);
    
    
    self.editBtn.layer.cornerRadius = 15;
    self.editBtn.layer.borderWidth = 1;
    self.editBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.editBtn.alpha = 0;
    [self.view insertSubview:back atIndex:0];
    [back setBlock:^(BOOL isEdit){
        if (isEdit) {
            self.editBtn.selected = YES;
        }
    }];
    self.backView = back;
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.backView changeEditState:sender.selected];
    
}

- (IBAction)addBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - 60;
    if (sender.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            self.editBtn.alpha = 1;
            sender.transform =  CGAffineTransformMakeRotation(M_PI_4);
            CGRect frame = self.backView.frame;
            frame.origin.y = 80;
            self.backView.frame = frame;
        }];
    }else{
        if (self.editBtn.selected) {
            self.editBtn.selected = NO;
            [self.backView changeEditState:NO];
        }
        [self.backView updateColumn:^(NSMutableArray *columnArray) {
            NSLog(@"%@",columnArray);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            self.editBtn.alpha = 0;
            sender.transform =  CGAffineTransformMakeRotation(0);
            CGRect frame = self.backView.frame;
            frame.origin.y = 80 - height;
            self.backView.frame = frame;
        }];
    }
    
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        NSMutableArray * arr1 = [[NSMutableArray alloc] init];
        [_dataSource addObject:arr1];
        NSMutableArray * arr2 = [[NSMutableArray alloc] init];
        [_dataSource addObject:arr2];
        for (NSInteger i = 0; i < 13; i++) {
            ColumnModel * model = [ColumnModel columnModelTitle:[NSString stringWithFormat:@"%ld",(long)i] state:itemStateNormol iconImage:@"icon"];
            [arr1 addObject:model];
        }
        for (NSInteger i = 0; i < 13; i++) {
            ColumnModel * model = [ColumnModel columnModelTitle:[NSString stringWithFormat:@"%ld",(long)i] state:itemStateRemove iconImage:@"icon"];
            [arr2 addObject:model];
        }
      
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
