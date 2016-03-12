//
//  PullToRefreshHeadView.h
//  pullToRefresh
//
//  Created by  songcaili on 16/3/9.
//  Copyright © 2016年  songcaili. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    PullToRefreshNormal = 0,  //下拉刷新
    PullToRefreshPulling,   //释放更新
    PullToRefreshLoading,  //加载中
} PullToRefreshState;

@protocol PullToRefreshHeadViewDelegate;
@interface PullToRefreshHeadView : UIView
@property(nonatomic,weak) id <PullToRefreshHeadViewDelegate> delegate;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol PullToRefreshHeadViewDelegate <NSObject>
- (void)refreshHeadViewDidTriggerRefresh:(PullToRefreshHeadView *)headView;

@end






