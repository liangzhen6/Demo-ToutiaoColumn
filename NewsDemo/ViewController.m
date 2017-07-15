//
//  ViewController.m
//  NewsDemo
//
//  Created by shenzhenshihua on 2017/7/13.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import "ColumnBackView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property(nonatomic,strong)ColumnBackView *backView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightTextColor];

    ColumnBackView * back = [ColumnBackView columnBackView];
    self.editBtn.layer.cornerRadius = 15;
    self.editBtn.layer.borderWidth = 1;
    self.editBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.view addSubview:back];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
