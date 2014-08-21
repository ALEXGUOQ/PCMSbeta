//
//  HDHNSFetchedResultsController.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-3-7.
//  Copyright (c) 2014年 天津米索软件有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  # 用于配置tableView,Cell的选择,长按等
 */
@protocol HDHNSFetchedResultsDelegate <NSObject>
/**
 *  实现这个方法来配置cell上的data数据
 *
 *  @param data      对应的数据
 *  @param cell      要配置的cell
 *  @param indexPath 对应的IndexPath
 */
- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath;
/**
 *  选择一条数据
 *
 *  @param data 对应的数据
 */
- (void)didSelectRowData:(id)data;
/**
 *  长按一条数据
 *
 *  @param data 对应的数据
 */
- (void)didLongPressRowData:(id)data;
@end
/**
 *  # 根据CoreData模型建立查询,结果用来配置tableView的通用类
 */
@interface HDHNSFetchedResultsController
    : NSObject <UITableViewDataSource, UITableViewDelegate,
                NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate>
/**
 *  控制数据自动更新的fetchedResultsController
 */
@property(nonatomic, strong)
    NSFetchedResultsController *hdhFetchedResultsController;
/**
 *  HDHNSFetchedResultsDelegate delegate
 */
@property(nonatomic, weak) id<HDHNSFetchedResultsDelegate> delegate;
/**
 *  模型名
 */
@property(nonatomic, weak) Class className;
/**
 *  cell的名称,重用名
 */
@property(nonatomic, copy) NSString *reuseIndentifier;
/**
 *  是否暂停自动化观察数据
 */
@property(nonatomic, assign) BOOL paused;
/**
 *  初始化对象
 *
 *  @param tableView tableView
 *
 *  @return instance实例
 */
- (id)initWithTableView:(UITableView *)tableView;

@end
