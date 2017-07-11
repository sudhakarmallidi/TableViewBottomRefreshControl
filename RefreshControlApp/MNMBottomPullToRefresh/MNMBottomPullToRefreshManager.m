/*
 */

#import "MNMBottomPullToRefreshManager.h"
#import "MNMBottomPullToRefreshView.h"

CGFloat const kAnimationDuration = 0.2f;

@interface MNMBottomPullToRefreshManager()

/*
 * Pull-to-refresh view
 */
@property (nonatomic, readwrite, strong) MNMBottomPullToRefreshView *pullToRefreshView;

/*
 * Table view which p-t-r view will be added
 */
@property (nonatomic, readwrite, weak) UITableView *table;

/*
 * Client object that observes changes
 */
@property (nonatomic, readwrite, weak) id<MNMBottomPullToRefreshManagerClient> client;

/*
 * Returns the correct offset to apply to the pull-to-refresh view, depending on contentSize
 *
 * @return The offset
 * @private
 */
- (CGFloat)tableScrollOffset;

@end

@implementation MNMBottomPullToRefreshManager

@synthesize pullToRefreshView = pullToRefreshView_;
@synthesize table = table_;
@synthesize client = client_;

#pragma mark -
#pragma mark Instance initialization

/*
 * Initializes the manager object with the information to link view and table
 */
- (id)initWithPullToRefreshViewHeight:(CGFloat)height tableView:(UITableView *)table withClient:(id<MNMBottomPullToRefreshManagerClient>)client {

    if (self = [super init]) {
        
        client_ = client;
        table_ = table;        
        pullToRefreshView_ = [[MNMBottomPullToRefreshView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([table_ frame]), height)];
    }
    
    return self;
}

#pragma mark -
#pragma mark Visuals

/*
 * Returns the correct offset to apply to the pull-to-refresh view, depending on contentSize
 */
- (CGFloat)tableScrollOffset {
    
    CGFloat offset = 0.0f;        
    
    if ([table_ contentSize].height < CGRectGetHeight([table_ frame])) {
        
        offset = -[table_ contentOffset].y;
        
    } else {
        
        offset = ([table_ contentSize].height - [table_ contentOffset].y) - CGRectGetHeight([table_ frame]);
    }
    
    return offset;
}

/*
 * Relocate pull-to-refresh view
 */
- (void)relocatePullToRefreshView {
    
    CGFloat yOrigin = 0.0f;
    
    if ([table_ contentSize].height >= CGRectGetHeight([table_ frame])) {
        
        yOrigin = [table_ contentSize].height;
        
    } else {
        
        yOrigin = CGRectGetHeight([table_ frame]);
    }
    
    CGRect frame = [pullToRefreshView_ frame];
    frame.origin.y = yOrigin;
    [pullToRefreshView_ setFrame:frame];
    
    [table_ addSubview:pullToRefreshView_];
}

/*
 * Sets the pull-to-refresh view visible or not. Visible by default
 */
- (void)setPullToRefreshViewVisible:(BOOL)visible {
    
    [pullToRefreshView_ setHidden:!visible];
}

#pragma mark -
#pragma mark Table view scroll management

/*
 * Checks state of control depending on tableView scroll offset
 */
- (void)tableViewScrolled {
    
    if (![pullToRefreshView_ isHidden] && ![pullToRefreshView_ isLoading]) {
        
        CGFloat offset = [self tableScrollOffset];

        if (offset >= 0.0f) {
            
            [pullToRefreshView_ changeStateOfControl:MNMBottomPullToRefreshViewStateIdle offset:offset];
            
        } else if (offset <= 0.0f && offset >= -[pullToRefreshView_ fixedHeight]) {
                
            [pullToRefreshView_ changeStateOfControl:MNMBottomPullToRefreshViewStatePull offset:offset];
            
        } else {
            
            [pullToRefreshView_ changeStateOfControl:MNMBottomPullToRefreshViewStateRelease offset:offset];
        }
    }
}

/*
 * Checks releasing of the tableView
 */
- (void)tableViewReleased {
    
    if (![pullToRefreshView_ isHidden] && ![pullToRefreshView_ isLoading]) {
        
        CGFloat offset = [self tableScrollOffset];
        CGFloat height = -[pullToRefreshView_ fixedHeight];
        
        if (offset <= 0.0f && offset < height) {
            
            [client_ bottomPullToRefreshTriggered:self];
            
            [pullToRefreshView_ changeStateOfControl:MNMBottomPullToRefreshViewStateLoading offset:offset];
            
            [UIView animateWithDuration:kAnimationDuration animations:^{
                
                if ([table_ contentSize].height >= CGRectGetHeight([table_ frame])) {
                
                    [table_ setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, -height, 0.0f)];
                    
                } else {
                    
                    [table_ setContentInset:UIEdgeInsetsMake(height, 0.0f, 0.0f, 0.0f)];
                }
            }];
        }
    }
}

/*
 * The reload of the table is completed
 */
- (void)tableViewReloadFinished {
    
    [table_ setContentInset:UIEdgeInsetsZero];

    [self relocatePullToRefreshView];

    [pullToRefreshView_ changeStateOfControl:MNMBottomPullToRefreshViewStateIdle offset:CGFLOAT_MAX];
}

@end
