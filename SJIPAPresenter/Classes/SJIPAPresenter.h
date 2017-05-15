//
//  SJIPAPresenter.h
//  Pods
//
//  Created by Sjoerd Janssen on 15/05/2017.
//
//

#import <UIKit/UIKit.h>

@interface IPA : NSObject

@property (nonatomic, strong) NSString *name, *identifier, *price;
@property (nonatomic, strong) NSArray *available, *missing;

@end

@class SJIPAPresenter;

@protocol SJIPAPresenterDelegate <NSObject>

- (void)valueHasChanged;

@required
- (UITableViewCell *)presenter:(SJIPAPresenter *)presenter cellForInAppPurchase:(IPA *)ipa indexPath:(NSIndexPath *)indexPath;

@end

@interface SJIPAPresenter : UIControl <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *ipas;
@property (nonatomic) id delegate;
@property (nonatomic, strong) UIColor *trackTintColor, *trackColor;

- (instancetype)initWithFrame:(CGRect)frame;
- (IPA *)value;
- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end
