//
//  MessageDetailsViewController.m
//  UCBMessage
//
//  Created by vmoksha mobility on 16/02/17.
//  Copyright © 2017 vmoksha mobility. All rights reserved.
//

#import "MessageDetailsViewController.h"

@interface MessageDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *messageBodyLabel;

@property (weak, nonatomic) IBOutlet UITextView *messageBodyTextView;
@end

@implementation MessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:.7 green:.92 blue:.96 alpha:1];
   // self.messageBodyLabel.text = _aModel.body;
    self.messageBodyTextView.text = _aModel.body;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
