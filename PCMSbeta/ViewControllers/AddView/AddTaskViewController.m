//
//  AddTaskViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-31.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "AddTaskViewController.h"
#import "AlertTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
/**
 *  # 新增或者修改任务
 */
@interface AddTaskViewController () <HDHNSFetchedResultsDelegate,CLLocationManagerDelegate,UIAlertViewDelegate> {
    UIDatePicker *datePicker;
    UITableView *alertTableView;
    PXAlertView *alert;
    HDHNSFetchedResultsController *result;
    NSString *selectedClientId;
    NSString *selectedCodeIdScore;
    NSString *locationString;
    CLLocation *location;
    UIAlertView *signInAlert;
}
/**
 *  位置服务管理对象
 */
@property (nonatomic ,strong) CLLocationManager *locationManager;
/**
 *  用户名(根据业务员id查询得到)
 */
@property (weak, nonatomic) IBOutlet UITextField *userName;
//tag = 1
/**
 *  任务日期
 */
@property (weak, nonatomic) IBOutlet UITextField *workDate;
//tag = 2
/**
 *  拜访单位(查询得到,显示当前用户id所创建的医院/代理商)
 */
@property (weak, nonatomic) IBOutlet UITextField *visitPlace;
/**
 *  任务名称
 */
@property (weak, nonatomic) IBOutlet UITextField *task;
/**
 *  完成情况
 */
@property (weak, nonatomic) IBOutlet UITextField *isCompleted;
/**
 *  备注
 */
@property (weak, nonatomic) IBOutlet UITextField *remark;
//tag = 6
/**
 *  评价(查询Code表得到)
 */
@property (weak, nonatomic) IBOutlet UITextField *score;
/**
 *  起签到时间,不可编辑
 */
@property (weak, nonatomic) IBOutlet UITextField *startedDateTime;
/**
 *  起签到地点,不可编辑
 */
@property (weak, nonatomic) IBOutlet UITextField *startedAddress;
/**
 *  止签到时间,不可编辑
 */
@property (weak, nonatomic) IBOutlet UITextField *endDateTime;
/**
 *  止签到地点,不可编辑
 */
@property (weak, nonatomic) IBOutlet UITextField *endAddress;
/**
 *  右上角保存按钮
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;
/**
 *  签到按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *signIn;

@end

@implementation AddTaskViewController

#pragma mark - lyfeCyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    if (_temp) {
        [self setViewContentEnabled];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 500.0f;
    [_locationManager startUpdatingLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAlertWhenEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
}

#pragma mark - Listener
/**
 *  实现点击TextField弹出选择列表
 *
 *  @param aNotification <#aNotification description#>
 */
- (void)showAlertWhenEditing:(NSNotification *)aNotification {
    if ([aNotification.object tag] == 1) {// workDate
        datePicker = [ViewBuilder datePickerByDateString:[_workDate.text  isEqual: @""] ? nil : [StringUtil get8BitDateStringFromFormatDateString:_workDate.text]];
        [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:@"取消" otherTitle:@"确定" contentView:datePicker completion:^(BOOL cancelled) {
            if (!cancelled) {
                [_workDate setText:[StringUtil get8BitFormateDateString:datePicker.date]];
            }
            [_workDate resignFirstResponder];
        }];
    } else if ([aNotification.object tag] == 2){//visitPlace
        alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:[self buildSegmentedControlTableView] completion:^(BOOL cancelled) {if(alert)alert = nil;
            [_visitPlace resignFirstResponder];
        }];
    } else if ([aNotification.object tag] == 6){// score
        
        alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:[self buildScorePickerTableView] completion:^(BOOL cancelled) {if(alert)alert = nil;
            [_score resignFirstResponder];
        }];
    }
}

#pragma mark - HDHNSFetchedResultsDelegate
/**
 *  @see HDHNSFetchedResultsDelegate
 *
 *  @param data <#data description#>
 */
- (void)didSelectRowData:(id)data {
    [alert dismiss:[[UIButton alloc] init]];
    if ([data isKindOfClass:[Client class]]) {
        Client *client = (Client *)data;
        _visitPlace.text = client.clientName;
        selectedClientId = client.clientId;
    } else if ([data isKindOfClass:[Agent class]]) {
        Agent *agent = (Agent *)data;
        _visitPlace.text = agent.agentName;
        selectedClientId = agent.agentId;
    } else if ([data isKindOfClass:[Code class]]) {
        Code *code = (Code *)data;
        _score.text = code.codeName;
        selectedCodeIdScore = code.codeId;
    }
}
/**
 *  @see HDHNSFetchedResultsDelegate
 *
 *  @param data      <#data description#>
 *  @param cell      <#cell description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath {
    AlertTableViewCell *aCell = (AlertTableViewCell *)cell;
    if ([data isKindOfClass:[Client class]]) {
        Client *client = (Client *)data;
        aCell.textLabel.text = client.clientName;
    } else if ([data isKindOfClass:[Agent class]]) {
        Agent *agent = (Agent *)data;
        aCell.textLabel.text = agent.agentName;
    } else if ([data isKindOfClass:[Code class]]) {
        Code *code = (Code *)data;
        aCell.textLabel.text = code.codeName;
    }
}
/**
 *  @see HDHNSFetchedResultsDelegate
 *
 *  @param data <#data description#>
 */
- (void)didLongPressRowData:(id)data {}

#pragma mark - Action
/**
 *  保存任务
 *
 *  @param sender <#sender description#>
 */
- (IBAction)save:(UIBarButtonItem *)sender {
    if ([StringUtil isNull:_task.text]|[StringUtil isNull:_workDate.text]) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"任务内容及日期不能为空!" afterDelay:1.0f];
    } else {
        [self updateTask];
    }
}
/**
 *  签到
 *
 *  @param sender <#sender description#>
 */
- (IBAction)signIn:(UIButton *)sender {
    if (_temp) {
        if (_temp.startDateTime == nil || _temp.endDateTime == nil) {
            [self getCurrentLocation];
        } else {
            [ViewBuilder autoDismissAlertViewWithTitle:@"签到已完成,不能重复签到!" afterDelay:2.5f];
        }
    } else {
        [ViewBuilder autoDismissAlertViewWithTitle:@"请先保存任务" afterDelay:1.2f];
    }
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    location = [locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error: %@", error);
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self postTaskWithLocationInfoToServer];
    }
}

#pragma mark - simple method
/**
 *  提交签到位置信息到服务器
 */
- (void)postTaskWithLocationInfoToServer {
    //<dh-x>%@<mh>%@
    __block UIAlertView *alertP = [ViewBuilder showAlertWithTitle:@"签到中..."];
    NSString *post = [[EntityUtil parseEntityToJsonObjectStr:_temp] stringByAppendingString:[NSString stringWithFormat:@"<dh-x>address<mh>%@",locationString]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:post forKey:@"data"];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP apiPath:SIGNIN_PATH customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:nil params:params httpMethod:@"POST"];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *re = [completedOperation responseString];
        NSLog(@"返回--------------------SignInTask---------------------数据：\n%@", re);
        if (![re isEqualToString:@"N"]) {
            NSDictionary *dic = [EntityUtil parseJsonObjectStrToDic:re];
            NSString *startTime = [dic valueForKey:@"startDateTime"];
            NSString *startAddr = [dic valueForKey:@"startAddress"];
            NSString *endTime = [dic valueForKey:@"endDateTime"];
            NSString *endAddr = [dic valueForKey:@"endAddress"];
            BOOL ret = [EntityUtil reflectDataFromOtherObject4Entity:_temp withData:dic];
            if (ret) {
                NSError *error;
                if ([MANAGED_OBJECT_CONTEXT save:&error]) {
                    [ViewBuilder performDismiss:alertP];
                    _startedDateTime.text = [StringUtil getDateFormatStringFrom14BitString:startTime];
                    _startedAddress.text = startAddr;
                    _endDateTime.text = [StringUtil getDateFormatStringFrom14BitString:endTime];
                    _endAddress.text = endAddr;
                }
            } else {
                [ViewBuilder performDismiss:alertP];
            }
        } else {
            [ViewBuilder performDismiss:alertP];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [ViewBuilder performDismiss:alertP];
    }];
    [engine enqueueOperation:operation];
}
/**
 *  获取当前设备默认位置
 */
- (void)getCurrentLocation {
    __block UIAlertView *alertV = [ViewBuilder showAlertWithTitle:@"正在定位,请稍候..."];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = placemarks[0];
            NSString *province = placemark.administrativeArea;
            province = province == nil ? @"" : province;
            NSString *city = placemark.locality;
            city = city == nil ? @"" : city;
            NSString *county = placemark.subLocality;
            county = county == nil ? @"" : county;
            NSString *town = placemark.thoroughfare;
            town = town == nil ? @"" : town;
            NSString *street = placemark.subThoroughfare;
            street = street == nil ? @"" : street;
            locationString = [NSString stringWithFormat:@"%@%@%@%@%@", province, city, county, town, street];
            if (![locationString isEqualToString:@""]) {
                signInAlert = [ViewBuilder showAlertWithTitle:locationString cancelTitle:@"确认签到"];
                signInAlert.delegate = self;
                [ViewBuilder performDismiss:alertV];
            }
        }
        if (error) {
            [ViewBuilder autoDismissAlertViewWithTitle:@"定位失败!请检查网络连接!" afterDelay:2.2f];
            [ViewBuilder performDismiss:alertV];
        }
    }];
}
/**
 *  编辑框权限控制,如果不是当前用户所创建的记录,不允许修改
 */
- (void)setViewContentEnabled {
    if (![_temp.userId isEqualToString:[[APP_DELEGATE currentUser] userId]]) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"没有编辑权限" afterDelay:1.5f];
        [_workDate setEnabled:FALSE];
        [_visitPlace setEnabled:FALSE];
        [_task setEnabled:FALSE];
        [_isCompleted setEnabled:FALSE];
        [_remark setEnabled:FALSE];
        [_score setEnabled:FALSE];
        [_save setEnabled:FALSE];
        [_signIn setEnabled:FALSE];
    }
}
/**
 *  评价选择列表
 *
 *  @return UIView
 */
- (UIView *)buildScorePickerTableView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 180)];
    alertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 180)];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"codeTypeId == '4'"];
    [alertTableView setBackgroundColor:[UIColor clearColor]];
    [alertTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    result = [[HDHNSFetchedResultsController alloc] initWithTableView:alertTableView];
    result.hdhFetchedResultsController = [Code fetchedResultsControllerWithPredicate:predicate];
    result.delegate = self;
    result.reuseIndentifier = @"AlertTableViewCell";
    [view addSubview:alertTableView];
    return view;
}
/**
 *  拜访单位选择列表
 *
 *  @return UIView
 */
- (UIView *)buildSegmentedControlTableView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"医院",@"代理商", nil]];
    [segmentedControl setFrame:CGRectMake(-2.5, 271, 205, 30)];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl setTintColor:[UIColor blackColor]];
    [segmentedControl addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    alertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 270)];
    [alertTableView setBackgroundColor:[UIColor clearColor]];
    [alertTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    result = [[HDHNSFetchedResultsController alloc] initWithTableView:alertTableView];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N' AND userId = %@",[[APP_DELEGATE currentUser] userId]];
    result.hdhFetchedResultsController = [Client fetchedResultsControllerWithPredicate:predicate];
    result.delegate = self;
    result.reuseIndentifier = @"AlertTableViewCell";
    [view addSubview:segmentedControl];
    [view addSubview:alertTableView];
    return view;
}
/**
 *  切换拜访单位选择列表
 *
 *  @param sender <#sender description#>
 */
- (void)segmentSelected:(id)sender {
    if ([(UISegmentedControl *)sender selectedSegmentIndex] == 1) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N' AND userId = %@",[[APP_DELEGATE currentUser] userId]];
        result.hdhFetchedResultsController = [Agent fetchedResultsControllerWithPredicate:predicate];
        [alertTableView reloadData];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N' AND userId = %@",[[APP_DELEGATE currentUser] userId]];
        result.hdhFetchedResultsController = [Client fetchedResultsControllerWithPredicate:predicate];
        [alertTableView reloadData];
    }
}
/**
 *  配置视图
 */
- (void)configView {
    
    NSString *visitedClient = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Client" withPredicate:[NSPredicate predicateWithFormat:@"clientId = %@", _temp.clientId]] lastObject] clientName];
    NSString *visitedAgent = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Agent" withPredicate:[NSPredicate predicateWithFormat:@"agentId = %@", _temp.clientId]] lastObject] agentName];
    
    _userName.text = !_temp ? [[APP_DELEGATE currentUser] userName] : [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"User" withPredicate:[NSPredicate predicateWithFormat:@"userId = %@", _temp.userId]] lastObject] userName];
    _workDate.text = [StringUtil getDateFormatStringFrom8BitString:_temp.workDate];
    _visitPlace.text = visitedAgent == nil ? visitedClient == nil ? nil : visitedClient : visitedAgent;
    _task.text = _temp.task;
    _isCompleted.text = _temp.content;
    _remark.text = _temp.remark;
    _score.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Code" withPredicate:[NSPredicate predicateWithFormat:@"codeId = %@", _temp.score]] lastObject] codeName];
    _startedDateTime.text = [StringUtil getDateFormatStringFrom14BitString:_temp.startDateTime];
    _startedAddress.text = _temp.startAddress;
    _endDateTime.text = [StringUtil getDateFormatStringFrom14BitString:_temp.endDateTime];
    _endAddress.text = _temp.endAddress;
    if (_readyDate) {
        _workDate.text = _readyDate;
    }
    if (_clientId) {
        _visitPlace.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Client" withPredicate:[NSPredicate predicateWithFormat:@"clientId = %@",_clientId]] lastObject] clientName];
    }
    if (_agentId) {
        _visitPlace.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Agent" withPredicate:[NSPredicate predicateWithFormat:@"agentId = %@",_agentId]] lastObject] agentName];
    }
}
/**
 *  更新(插入或修改)记录
 */
- (void)updateTask {
    Task *tk;
    if (_temp) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskId = %@",_temp.taskId];
        tk = (Task *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Task" withPredicate:predicate] lastObject];
    } else {
        tk = (Task *)[CoreDataUtil createData:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] modelName:@"Task"];
        tk.createDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
        tk.taskId = [StringUtil createUUID];
    }
    tk.workDate = [StringUtil get8BitDateStringFromFormatDateString:_workDate.text];
    if (selectedClientId) {
        tk.clientId = selectedClientId;
    } else {
        if (_clientId) {
            tk.clientId = _clientId;
        } else if (_agentId) {
            tk.clientId = _agentId;
        } else if (_temp.clientId) {
            tk.clientId = _temp.clientId;
        } else {
            tk.clientId = nil;
        }
    }
    tk.task = _task.text;
    tk.content = _isCompleted.text;
    tk.score = selectedCodeIdScore;
    
    tk.remark = _remark.text;
    tk.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
    tk.isDelete = @"N";
    tk.lastOperatorId = [[APP_DELEGATE currentUser] userId];
    tk.userId = [[APP_DELEGATE currentUser] userId];
    NSError *error = nil;
    if (![MANAGED_OBJECT_CONTEXT save:&error]) {
        NSLog(@"sorry %@", [error localizedDescription]);
    } else {
        [ViewBuilder autoDismissAlertViewWithTitle:@"保存成功!" afterDelay:0.5f];
    }
    _temp = tk;
}

@end
