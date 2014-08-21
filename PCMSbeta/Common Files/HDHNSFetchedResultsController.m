//
//  HDHNSFetchedResultsController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-3-7.
//  Copyright (c) 2014年 天津米索软件有限公司. All rights reserved.
//

#import "HDHNSFetchedResultsController.h"

@interface HDHNSFetchedResultsController ()

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation HDHNSFetchedResultsController

- (id)initWithTableView:(UITableView *)tableView {
  if (self = [super init]) {
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5f;
    longPress.delegate = self;
    [self.tableView addGestureRecognizer:longPress];
  }
  return self;
}

#pragma mark - TableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return self.hdhFetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)sectionIndex {
  id<NSFetchedResultsSectionInfo> section =
      self.hdhFetchedResultsController.sections[sectionIndex];
  return section.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:_reuseIndentifier];
    if (cell == nil) {
        Class someClass = NSClassFromString(_reuseIndentifier);

        cell = [[someClass alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:_reuseIndentifier];
    }
    id data = [_hdhFetchedResultsController objectAtIndexPath:indexPath];
  [_delegate configCellData:data cell:cell index:indexPath];
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  id data = [_hdhFetchedResultsController objectAtIndexPath:indexPath];
  [_delegate didSelectRowData:data];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
  CGPoint p = [gestureRecognizer locationInView:_tableView];
  if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:p];
      [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    id data = [_hdhFetchedResultsController objectAtIndexPath:indexPath];
      if (data) {
          [_delegate didLongPressRowData:data];
      }
  }
}

#pragma mark - 设置fetchedresults的delegate

- (void)setHdhFetchedResultsController:
            (NSFetchedResultsController *)hdhFetchedResultsController {
  _hdhFetchedResultsController = hdhFetchedResultsController;
  hdhFetchedResultsController.delegate = self;
  NSError *error;
  if (![hdhFetchedResultsController performFetch:&error]) { //启动
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
  }
}

#pragma mark - 暂停的方法,比u说对应的视图被隐藏的时候就让自动更新几只暂停,当回到视图的时候再让它开始
- (void)setPaused:(BOOL)paused {
  _paused = paused;
  if (paused) {
    self.hdhFetchedResultsController.delegate = nil;
  } else {
    self.hdhFetchedResultsController.delegate = self;
    [self.hdhFetchedResultsController performFetch:NULL];
    [self.tableView reloadData];
  }
}

#pragma mark - fetchedResults delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
    didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath {
  UITableView *tableView = self.tableView;

  switch (type) {

  case NSFetchedResultsChangeInsert:
    [tableView insertRowsAtIndexPaths:@[ newIndexPath ]
                     withRowAnimation:UITableViewRowAnimationFade];
    break;

  case NSFetchedResultsChangeDelete:
    [tableView deleteRowsAtIndexPaths:@[ indexPath ]
                     withRowAnimation:UITableViewRowAnimationFade];
    break;

  case NSFetchedResultsChangeUpdate:
    [tableView reloadRowsAtIndexPaths:@[ indexPath ]
                     withRowAnimation:UITableViewRowAnimationFade];
    break;

  case NSFetchedResultsChangeMove:
    [tableView deleteRowsAtIndexPaths:@[ indexPath ]
                     withRowAnimation:UITableViewRowAnimationFade];
    [tableView insertRowsAtIndexPaths:@[ newIndexPath ]
                     withRowAnimation:UITableViewRowAnimationFade];
    break;
  default:
    NSAssert(NO, @"");
    break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
}

@end
