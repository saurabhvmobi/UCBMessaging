//
//  MessageViewController.m
//  UCBMessage
//
//  Created by vmoksha mobility on 09/02/17.
//  Copyright © 2017 vmoksha mobility. All rights reserved.
//

#import "MessageViewController.h"
#import "DBManager.h"
#import "MessageModel.h"
@interface MessageViewController ()<DBManagerDelegate>
{
    NSMutableArray *messageArray;
    DBManager *dbManager;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConst;


@end



@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    messageArray =[[NSMutableArray alloc]init];
    [self getData];
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
    
    MessageModel *aModel = messageArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UIView *containerView = (UIView *)[cell viewWithTag:111];
    containerView.layer.cornerRadius = 15;
    containerView.layer.masksToBounds = YES;
    UILabel *titleLable = (UILabel *)[cell viewWithTag:100];
    UILabel *subtitleLable = (UILabel *)[cell viewWithTag:101];
    UILabel *bodyLable = (UILabel *)[cell viewWithTag:102];
    titleLable.text = aModel.title;
    subtitleLable.text = aModel.subtitle;
    bodyLable.text = aModel.body;
    
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


-(void)getData
{
    if (dbManager == nil)
    {
        dbManager = [[DBManager alloc] initWithFileName:@"UCBMessage.db"];
        dbManager.delegate=self;
    }
    NSString *queryString = @"SELECT * FROM Message";
    [dbManager getDataForQuery:queryString];

}
- (void)DBManager:(DBManager *)manager gotSqliteStatment:(sqlite3_stmt *)statment
{
    
        while (sqlite3_step(statment) == SQLITE_ROW)
        {
            MessageModel *aModel = [[MessageModel alloc] init];
            aModel.body = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 0)];
            aModel.subtitle = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 1)];
            aModel.title = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statment, 2)];
            [messageArray addObject:aModel];
        }
       [self.tableView reloadData];
}




@end
