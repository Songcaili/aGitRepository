//
//  PullToRefreshHeadView.m
//  pullToRefresh
//
//  Created by  songcaili on 16/3/9.
//  Copyright © 2016年  songcaili. All rights reserved.
//

#import "PullToRefreshHeadView.h"

@interface PullToRefreshHeadView () {
    PullToRefreshState _state;
}
@property(nonatomic,strong) UILabel *textLabel;
@property(nonatomic,strong) CALayer *arrowLayer;
@property(nonatomic,strong) UIActivityIndicatorView *activityView;

@end

@implementation PullToRefreshHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:250.0/255 green:250.0/255 blue:250.0/255 alpha:1.0f];
        CGFloat textWidth = 52;
        CGRect arrowRect = CGRectMake((KSCREEN_WIDTH-45-10)/2, frame.size.height-40, 10, 20);
        _arrowLayer = [CALayer layer];
        _arrowLayer.frame = arrowRect;
        _arrowLayer.contents = (id)[UIImage imageNamed:@"row"].CGImage;
        [[self layer] addSublayer:_arrowLayer];
    
        CGFloat textX = CGRectGetMaxX(arrowRect)+10;
        CGRect textRect = CGRectMake(textX, frame.size.height-40, textWidth, 20);
        _textLabel = [[UILabel alloc] initWithFrame:textRect];
        [_textLabel setFont:[UIFont systemFontOfSize:13.0f]];
        _textLabel.textColor = [UIColor grayColor];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.text = @"下拉刷新";
        [self addSubview:_textLabel];
        
        CGRect actiViewRect = CGRectMake(CGRectGetMinX(arrowRect)-5, CGRectGetMinY(arrowRect), 20, 20);
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:actiViewRect];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:_activityView];
        
    }
    return self;
    
}

- (void)setState:(PullToRefreshState)state {
    
    switch (state) {
        case PullToRefreshNormal:
            if (_state == PullToRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:.15];
                _arrowLayer.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            _textLabel.text = @"下拉刷新";
            _arrowLayer.hidden = NO;
            _arrowLayer.transform = CATransform3DIdentity;
            [_activityView stopAnimating];
            break;
        case PullToRefreshPulling:
            _textLabel.text = @"释放更新";
            _arrowLayer.hidden = NO;
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:.15f];
            _arrowLayer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            
            [_activityView stopAnimating];
            break;
        case PullToRefreshLoading:
            _textLabel.text = @"加载中";
            [_activityView startAnimating];
            _arrowLayer.hidden = YES;
            break;
        default:
            break;
    }
    _state = state;
    
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.isDragging) {
        if (_state == PullToRefreshNormal && scrollView.contentOffset.y < -65) {
            [self setState:PullToRefreshPulling];
        }else if(scrollView.contentOffset.y > -65 ){
            scrollView.bounces = YES;
            scrollView.contentInset = UIEdgeInsetsZero;
            [self setState:PullToRefreshNormal];
        }
    }
    
}

-(void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    if (_state == PullToRefreshPulling || scrollView.contentOffset.y < -65) {
        scrollView.bounces = NO;
        [self setState:PullToRefreshLoading];
        if ([_delegate respondsToSelector:@selector (refreshHeadViewDidTriggerRefresh:)]) {
            [_delegate refreshHeadViewDidTriggerRefresh:self];
        }
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.15f];
        scrollView.contentInset = UIEdgeInsetsMake(60, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
    }
    
}

- (void)refreshScrollViewDidFinishedLoading:(UIScrollView *)scrollView {
   
    scrollView.bounces = YES;
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [scrollView setContentOffset:CGPointMake(0.0f, 0.0f)];
    [self setState:PullToRefreshNormal];
    
}

@end
