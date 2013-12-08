//
//  LeaderboardViewController.m
//  KillBlocks
//
//  Created by Attila Csala on 12/8/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "LeaderboardViewController.h"

@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController


-(UITableViewCell*) tableView:(UITableView *)tableView
             cellForKiiObject:(KiiObject*)object
                  atIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"MyCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleSubtitle
                             reuseIdentifier:identifier];
    
    cell.textLabel.text = [[object getObjectForKey:@"score"] description];
    cell.detailTextLabel.text = [object getObjectForKey:@"username"];
    
    
    return cell;
    
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    header.backgroundColor = [UIColor orangeColor];
    
    // close button to close the leaderboard
    UIButton *close = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [close setTitle:@"Done" forState:UIControlStateNormal];
    close.frame = CGRectMake(260, 20, 60, 40);
    [close addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:close];
    
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 40)];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.text = [NSString stringWithFormat:@"Your score: %d", _userScore];
    [header addSubview:scoreLabel];
    
    return header;
}


-(void) closeView:(id)sender{
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return  100.0f;
    
}

@end
