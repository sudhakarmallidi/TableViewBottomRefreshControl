/*
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 * Enumerates control state
 */
typedef enum {
    
    MNMBottomPullToRefreshViewStateIdle = 0, //<! The control is invisible right after being created or after a reloading was completed
    MNMBottomPullToRefreshViewStatePull, //<! The control is becoming visible and shows "pull to refresh" message
    MNMBottomPullToRefreshViewStateRelease, //<! The control is whole visible and shows "release to load" message
    MNMBottomPullToRefreshViewStateLoading //<! The control is loading and shows activity indicator
    
} MNMBottomPullToRefreshViewState;

/**
 * Pull to refresh view. Its state is managed by an instance of MNMBottomPullToRefreshManager.
 */
@interface MNMBottomPullToRefreshView : UIView

/**
 * Returns YES if view is in Loading state.
 */
@property (nonatomic, readonly, assign) BOOL isLoading;

/**
 * Fixed height of the view. This value is used to trigger the refreshing.
 */
@property (nonatomic, readonly) CGFloat fixedHeight;

/**
 * Changes the state of the control depending on state value.
 *
 * Values of *MNMBottomPullToRefreshViewState*:
 *
 * - `MNMBottomPullToRefreshViewStateIdle` The control is invisible right after being created or after a reloading was completed.
 * - `MNMBottomPullToRefreshViewStatePull` The control is becoming visible and shows "pull to refresh" message.
 * - `MNMBottomPullToRefreshViewStateRelease` The control is whole visible and shows "release to load" message.
 * - `MNMBottomPullToRefreshViewStateLoading` The control is loading and shows activity indicator.
 *
 * @param state The state to set.
 * @param offset The offset of the table scroll.
 */
- (void)changeStateOfControl:(MNMBottomPullToRefreshViewState)state offset:(CGFloat)offset;

@end
