//
//  SJViewController.m
//  SJIPAPresenter
//
//  Created by sjoerdjanssenen on 05/15/2017.
//  Copyright (c) 2017 sjoerdjanssenen. All rights reserved.
//

#import "SJViewController.h"
@import SJIPAPresenter;

@interface SJViewController ()

@property (nonatomic, strong) SJIPAPresenter *presenter;

@end

@implementation SJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    IPA *first = [[IPA alloc] init];
    first.name = @"first";
    first.available = @[@"available1"];
    first.missing = @[@"missing2", @"missing3", @"missing4"];
    first.price = @"Free";
    IPA *second = [[IPA alloc] init];
    second.name = @"second";
    second.available = @[@"available1", @"available2"];
    second.missing = @[@"missing3", @"missing4"];
    second.price = @"€ 4,99";
    IPA *third = [[IPA alloc] init];
    third.name = @"third";
    third.available = @[@"available1", @"available2", @"available3", @"available4"];
    third.missing = @[];
    third.price = @"€ 9,99";
    
    CGFloat size = self.view.frame.size.width-20;
    self.presenter = [[SJIPAPresenter alloc] initWithFrame:CGRectMake((self.view.frame.size.width-size)/2, (self.view.frame.size.height-size)/2, size, size)];
    [self.presenter setIpas:@[first, second, third]];
    self.presenter.delegate = self;
    self.presenter.trackTintColor = [UIColor purpleColor];
    self.presenter.trackColor = [UIColor lightGrayColor];
    [self.view addSubview:self.presenter];
}

- (void)valueHasChanged {
    self.title = self.presenter.value.name;
}

- (UITableViewCell *)presenter:(SJIPAPresenter *)presenter cellForInAppPurchase:(IPA *)ipa indexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [presenter dequeueReusableCellWithIdentifier:@"normalCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normalCell"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [ipa.available objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];
    } else {
        cell.textLabel.text = [ipa.missing objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

@end
