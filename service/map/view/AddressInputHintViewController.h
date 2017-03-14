//
//  AddressInputHintViewController.h
//  QQing
//
//  Created by 李杰 on 2/5/15.
//
//

#import "BaseViewController.h"

@protocol AddressInputHintViewControllerDelegate <NSObject>

- (void)addressItemClick:(id)obj;

@end


@interface AddressInputHintViewController : BaseViewController

@property (strong, nonatomic) AMapSearchAPI *search;

@property (strong, nonatomic) NSString *initialSearchString;

@property (strong, nonatomic) ObjectBlock completionBlock; // ???
@property (nonatomic,weak) id <AddressInputHintViewControllerDelegate>delegate;
- (id)initWithSearchAPI:(AMapSearchAPI *)searchAPI completion:(ObjectBlock)completion;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
