//
//  AddressInputHintViewController.m
//  QQing
//
//  Created by 李杰 on 2/5/15.
//
//
#import <AMapSearchKit/AMapSearchKit.h>
#import "AddressInputHintViewController.h"
#import "UserCityService.h"
#import "_ui_core.h"
#import "_vendor_lumberjack.h"

@interface AddressInputHintViewController () <UISearchBarDelegate,
                                              UITableViewDataSource,
                                              UITableViewDelegate,
                                              AMapSearchDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *displayController;
@property (strong,nonatomic) UIView *topView;
@property (strong, nonatomic) NSMutableArray *tips;

@end

@implementation AddressInputHintViewController
@synthesize tips = _tips;
@synthesize searchBar = _searchBar;
@synthesize displayController = _displayController;
@synthesize completionBlock = _completionBlock;
@synthesize search = _search;

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"所在区域";
    
    self.tips = [NSMutableArray array];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

    [self initSearchBar];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization


- (id)initWithSearchAPI:(AMapSearchAPI *)searchAPI completion:(ObjectBlock)completion {
    if (self = [super init]) {
        self.tips = [NSMutableArray array];
        [self setNavTitleString:@"当前位置"];
        self.search = searchAPI;
        self.search.delegate = self;
        self.completionBlock = completion;
    }
    return self;
}

- (void)initSearchBar {
    // Get navigation bar.
    self.view.backgroundColor = [UIColor viewBackgroundColor];
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 50)];
    [self.view addSubview:_topView];
    _topView.backgroundColor = [UIColor whiteColor];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(8, 3, screen_width-16, 44)];
    self.searchBar.tintColor = [UIColor fontGray_one_Color_deprecated];
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.backgroundColor = [UIColor whiteColor];
    
    self.searchBar.translucent = YES;
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"搜索";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    [self.searchBar becomeFirstResponder];
    self.searchBar.tintColor = [UIColor colorWithRed:108.0/255 green:186.0/255 blue:82.0/255 alpha:1];
    self.searchBar.text = self.initialSearchString ? self.initialSearchString : @"";
    if (self.searchBar.text.length > 0) {
        [self searchTipsWithKey:self.searchBar.text];
    }
    [_topView addSubview:self.searchBar];
}

- (void)initTableView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, self.topView.height+5, screen_width-2*5, screen_height-self.topView.height-2*5-64)];
    [self.view addSubview:view];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view bringSubviewToFront:self.tableView];
}

#pragma mark - Utility

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key {
    if (key.length == 0)
    {
        return;
    }
    NSString *address = [[UserCityService  sharedInstance] getUserCityName];
    
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    if (address.length > 0) {
        tips.city = address;
    }
    
    [self.search AMapInputTipsSearch:tips];
}

#pragma mark - Action handle

- (void)didClickOnAddressItem:(id)obj {
    if ([self.delegate respondsToSelector:@selector(addressItemClick:)]) {
        [self.delegate performSelector:@selector(addressItemClick:) withObject:obj];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchTipsWithKey:searchText];
}

#pragma mark - AMapSearchDelegate

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    NSMutableArray *tipsArray = [NSMutableArray array];
    for (AMapTip *tip in response.tips) {
        if ([tip.adcode length] != 0) {
            [tipsArray addObject:tip];
        }
    }
    [self.tips setArray:tipsArray];
    [self.tableView reloadData];
   // [self.displayController.searchResultsTableView reloadData];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    DDLogError(@"地址搜索.高德搜索API失败,error=%@",error);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    if (tip.district.length > 0) {
        cell.textLabel.text = [tip.district stringByAppendingString:tip.name];
    } else {
        cell.textLabel.text = tip.name;
    }
    cell.textLabel.textColor = [UIColor fontGray_one_Color_deprecated];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AMapTip *tip = self.tips[indexPath.row];

    self.searchBar.placeholder = tip.name;
    [self performSelector:@selector(didClickOnAddressItem:) withObject:tip];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.tableView == scrollView) {
        [self.searchBar resignFirstResponder];
    }
}

@end
