//
//  MessageViewController.m
//  UCBMessage
//
//  Created by vmoksha mobility on 09/02/17.
//  Copyright © 2017 vmoksha mobility. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()
{
    NSMutableArray *messageArray;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConst;


@end



@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    messageArray = @[@"1",@"1",@"1"].mutableCopy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self adjustTableViewHeigth];


}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  messageArray.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UIView *containerView = (UIView *)[cell viewWithTag:111];
    containerView.layer.cornerRadius = 15;
    containerView.layer.masksToBounds = YES;
    UILabel *titleLable = (UILabel *)[cell viewWithTag:100];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UILabel *titleLable = (UILabel *)[cell viewWithTag:100];
    titleLable.backgroundColor = [UIColor redColor];
}



- (void)adjustTableViewHeigth
{
    NSInteger noOfCells = [messageArray count];
   
    CGFloat cellHeigth = [self.tableView rowHeight];
    
    CGFloat heigthOfTableView = cellHeigth*noOfCells;
    
   // heigthOfTableView = MIN(heigthOfTableView, self.containerView.frame.size.height);
    
    self.tableHeightConst.constant = heigthOfTableView;
  //  [self.containerView layoutIfNeeded];
}



@end
