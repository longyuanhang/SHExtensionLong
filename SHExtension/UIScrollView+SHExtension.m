//
//  UIScrollView+SHExtension.m
//  SHExtensionExample
//
//  Created by CCSH on 2022/1/27.
//  Copyright © 2022 CSH. All rights reserved.
//

#import "UIScrollView+SHExtension.h"

@implementation UIScrollView (SHExtension)

//MARK: - 刷新
- (void)refreshHeaderBlock:(RefreshCallback)block {
    //    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    //    header.stateLabel.font = kFont(12);
    //    header.lastUpdatedTimeLabel.hidden = YES;
    //    self.mj_header = header;
}

- (void)refreshFooterBlock:(RefreshCallback)block {
    //    MJRefreshBackNormalFooter *footer = [RefreshCallback footerWithRefreshingBlock:block];
    //    footer.stateLabel.font = kFont(12);
    //    self.mj_footer = footer;
}

- (void)stopAllrefresh {
    //    if (self.mj_header.state == MJRefreshStateRefreshing){
    //        [self.mj_header endRefreshing];
    //    }
    //    if (self.mj_footer.state == MJRefreshStateRefreshing){
    //        [self.mj_footer endRefreshing];
    //    }
}

//MARK: - 注册cell
- (void)registerClass:(NSString *)name {
    [self registerClass:name kind:nil];
}

- (void)registerClass:(NSString *)name kind:(NSString *)kind {
    Class class = NSClassFromString(name);
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *view = (UITableView *)self;
        if (kind.length) {
            [view registerClass:class forHeaderFooterViewReuseIdentifier:kind];
        } else {
            [view registerClass:class forCellReuseIdentifier:name];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *view = (UICollectionView *)self;
        if (kind.length) {
            [view registerClass:class forSupplementaryViewOfKind:kind withReuseIdentifier:name];
        } else {
            [view registerClass:class forCellWithReuseIdentifier:name];
        }
    }
}

- (void)registerNib:(NSString *)name {
    [self registerNib:name kind:nil];
}

- (void)registerNib:(NSString *)name kind:(NSString *)kind {
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *view = (UITableView *)self;
        if (kind.length) {
            [view registerNib:nib forHeaderFooterViewReuseIdentifier:name];
        } else {
            [view registerNib:nib forCellReuseIdentifier:name];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *view = (UICollectionView *)self;
        if (kind.length) {
            [view registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:name];
        } else {
            [view registerNib:nib forCellWithReuseIdentifier:name];
        }
    }
}

//MARK: - 获取cell
- (UITableViewCell *)dequeueCellWithIdentifier:(NSString *)identifier{
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *view = (UITableView *)self;
        UITableViewCell *cell = [view dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NSClassFromString(identifier) init] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
    return [UITableViewCell new];
}

@end
