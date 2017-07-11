/*
 */

@class MNMBottomPullToRefreshView;
@class MNMBottomPullToRefreshManager;

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * Delegate protocol to implement by MNMBottomPullToRefreshManager observers to track and manage pull-to-refresh view behavior.
 */
@protocol MNMBottomPullToRefreshManagerClient

/**
 * This is the same delegate method of UIScrollViewDelegate but required in MNMBottomPullToRefreshManagerClient protocol
 * to warn about its implementation.
 *
 * In the implementacion call [MNMBottomPullToRefreshManager tableViewScrolled] to indicate that the table is scrolling.
 *
 * @param scrollView The scroll-view object in which the scrolling occurred.
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/**
 * This is the same delegate method of UIScrollViewDelegate but required in MNMBottomPullToRefreshClient protocol
 * to warn about its implementation.
 *
 * In the implementacion call [MNMBottomPullToRefreshManager tableViewReleased] to indicate that the table has been released.
 *
 * @param scrollView The scroll-view object that finished scrolling the content view.
 * @param decelerate YES if the scrolling movement will continue, but decelerate, after a touch-up gesture during a dragging operation.
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

/**
 * Tells client that refresh has been triggered.
 *
 * After reload is completed call [MNMBottomPullToRefreshManager tableViewReloadFinished] to get back the view to Idle state
 *
 * @param manager The pull to refresh manager.
 */
- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager;

@end

#pragma mark -

/**
 * Manager that plays Mediator role and manages relationship between pull-to-refresh view and its associated table. 
 */
@interface MNMBottomPullToRefreshManager : NSObject

/**
 * Initializes the manager object with the information to link the view and the table.
 *
 * @param height The height that the pull-to-refresh view will have.
 * @param table Table view to link pull-to-refresh view to.
 * @param client The client that will observe behavior.
 */
- (id)initWithPullToRefreshViewHeight:(CGFloat)height tableView:(UITableView *)table withClient:(id)client;

/**
 * Relocate pull-to-refresh view at the bottom of the table taking into account the frame and the content offset.
 */
- (void)relocatePullToRefreshView;

/**
 * Sets the pull-to-refresh view visible or not. Visible by default.
 *
 * @param visible YES to make visible.
 */
- (void)setPullToRefreshViewVisible:(BOOL)visible;

/**
 * Has to be called when the table is being scrolled. Checks the state of control depending on the offset of the table.
 */
- (void)tableViewScrolled;

/**
 * Has to be called when table dragging ends. Checks the triggering of the refresh.
 */
- (void)tableViewReleased;

/**
 * Indicates that the reload of the table is completed. Resets the state of the view to Idle.
 */
- (void)tableViewReloadFinished;

@end
