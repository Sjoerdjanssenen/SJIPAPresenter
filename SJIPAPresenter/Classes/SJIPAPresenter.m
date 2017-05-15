//
//  SJIPAPresenter.m
//  Pods
//
//  Created by Sjoerd Janssen on 15/05/2017.
//
//

#import "SJIPAPresenter.h"

@implementation IPA

@end

@interface SJIPAPresenter()

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) IPA *current;
@property (nonatomic, strong) UITableView *features;
@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation SJIPAPresenter

@synthesize delegate;
@synthesize ipas = _ipas;
@synthesize current = _current;
@synthesize trackTintColor = _trackTintColor;
@synthesize trackColor = _trackColor;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(16, self.frame.size.height-50, self.frame.size.width-32, 30)];
        self.slider.minimumValue = 0;
        self.slider.continuous = YES;
        [self.slider addTarget:self
                        action:@selector(valueChanged:)
              forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.slider];
        
        self.features = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-50)];
        self.features.delegate = self;
        self.features.dataSource = self;
        self.features.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.features];
    }
    return self;
}

- (void)valueChanged:(UISlider *)sender {
    NSUInteger index = (NSUInteger)(self.slider.value + 0.5);
    [self.slider setValue:index animated:NO];
    self.current = [self.ipas objectAtIndex:index];
}

- (void)setCurrent:(IPA *)current {
    _current = current;
    
    [self.features reloadData];
    
    if ([delegate respondsToSelector:@selector(valueHasChanged)]) {
        [delegate valueHasChanged];
    }
}

- (IPA *)current {
    return _current;
}

- (void)setIpas:(NSArray *)ipas {
    _ipas = ipas;
    self.current = [ipas objectAtIndex:0];
    self.slider.maximumValue = [ipas count]-1;
    
    [self addLabels];
}

- (void)addLabels {
    for (UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    self.labels = [@[] mutableCopy];
    
    int numberOfTicks = [self.ipas count];
    
    CGFloat labelSpacing = self.slider.frame.size.width/(numberOfTicks-1);
    CGFloat yPosition = self.frame.size.height-20;
    
    for (int i = 0; i < numberOfTicks; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.adjustsFontSizeToFitWidth = YES;
        label.text = ((IPA *)[self.ipas objectAtIndex:i]).price;
        [label sizeToFit];
        
        CGFloat left = 0;
        if (i == 0) {
            left = 18.0f;
            label.textAlignment = NSTextAlignmentLeft;
        } else if (i == numberOfTicks-1) {
            left = self.slider.frame.size.width-label.frame.size.width+16;
            label.textAlignment = NSTextAlignmentRight;
        } else {
            left = (self.slider.frame.origin.x+labelSpacing)-(label.frame.size.width/2);
        }
        
        label.textColor = self.slider.maximumTrackTintColor;
        label.frame = CGRectMake(left, yPosition, label.frame.size.width, 20);
        [self addSubview:label];
        [self.labels addObject:label];
    }
}

- (NSArray *)ipas {
    return _ipas;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    _trackTintColor = trackTintColor;
    self.slider.minimumTrackTintColor = trackTintColor;
}

- (UIColor *)trackTintColor {
    return _trackTintColor;
}

- (void)setTrackColor:(UIColor *)trackColor {
    _trackColor = trackColor;
    self.slider.maximumTrackTintColor = trackColor;
    [self addLabels];
}

- (UIColor *)trackColor {
    return _trackColor;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.current.available count];
    } else {
        return [self.current.missing count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [delegate presenter:self cellForInAppPurchase:self.current indexPath:indexPath];
}

- (IPA *)value {
    return self.current;
}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    return [self.features dequeueReusableCellWithIdentifier:identifier];
}

@end
