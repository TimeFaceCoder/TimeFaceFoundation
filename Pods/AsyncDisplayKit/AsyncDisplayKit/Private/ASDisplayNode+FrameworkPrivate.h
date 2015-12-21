/* Copyright (c) 2014-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

//
// The following methods are ONLY for use by _ASDisplayLayer, _ASDisplayView, and ASDisplayNode.
// These methods must never be called or overridden by other classes.
//

#import "_ASDisplayLayer.h"
#import "_AS-objc-internal.h"
#import "ASDisplayNodeExtraIvars.h"
#import "ASDisplayNode.h"
#import "ASSentinel.h"
#import "ASThread.h"
#import "ASLayoutOptions.h"

/**
 Hierarchy state is propogated from nodes to all of their children when certain behaviors are required from the subtree.
 Examples include rasterization and external driving of the .interfaceState property.
 By passing this information explicitly, performance is optimized by avoiding iteration up the supernode chain.
 Lastly, this avoidance of supernode traversal protects against the possibility of deadlocks when a supernode is
 simultaneously attempting to materialize views / layers for its subtree (as many related methods require property locking)
 
 Note: as the hierarchy deepens, more state properties may be enabled.  However, state properties may never be disabled /
 cancelled below the point they are enabled.  They continue to the leaves of the hierarchy.
 */

typedef NS_OPTIONS(NSUInteger, ASHierarchyState)
{
  /** The node may or may not have a supernode, but no supernode has a special hierarchy-influencing option enabled. */
  ASHierarchyStateNormal       = 0,
  /** The node has a supernode with .shouldRasterizeDescendants = YES.
      Note: the root node of the rasterized subtree (the one with the property set on it) will NOT have this state set. */
  ASHierarchyStateRasterized   = 1 << 0,
  /** The node or one of its supernodes is managed by a class like ASRangeController.  Most commonly, these nodes are
      ASCellNode objects or a subnode of one, and are used in ASTableView or ASCollectionView.
      These nodes also recieve regular updates to the .interfaceState property with more detailed status information. */
  ASHierarchyStateRangeManaged = 1 << 1,
};

@interface ASDisplayNode () <_ASDisplayLayerDelegate>
{
@protected
  ASInterfaceState _interfaceState;
  ASHierarchyState _hierarchyState;
}

// These methods are recursive, and either union or remove the provided interfaceState to all sub-elements.
- (void)enterInterfaceState:(ASInterfaceState)interfaceState;
- (void)exitInterfaceState:(ASInterfaceState)interfaceState;

// These methods are recursive, and either union or remove the provided hierarchyState to all sub-elements.
- (void)enterHierarchyState:(ASHierarchyState)hierarchyState;
- (void)exitHierarchyState:(ASHierarchyState)hierarchyState;

/**
 * @abstract Returns the Hierarchy State of the node.
 *
 * @return The current ASHierarchyState of the node, indicating whether it is rasterized or managed by a range controller.
 *
 * @see ASInterfaceState
 */
@property (nonatomic, readwrite) ASHierarchyState hierarchyState;

// The two methods below will eventually be exposed, but their names are subject to change.
/**
 * @abstract Ensure that all rendering is complete for this node and its descendents.
 *
 * @discussion Calling this method on the main thread after a node is added to the view heirarchy will ensure that
 * placeholder states are never visible to the user.  It is used by ASTableView, ASCollectionView, and ASViewController
 * to implement their respective ".neverShowPlaceholders" option.
 *
 * If all nodes have layer.contents set and/or their layer does not have -needsDisplay set, the method will return immediately.
 *
 * This method is capable of handling a mixed set of nodes, with some not having started display, some in progress on an
 * asynchronous display operation, and some already finished.
 *
 * In order to guarantee against deadlocks, this method should only be called on the main thread.
 * It may block on the private queue, [_ASDisplayLayer displayQueue]
 */
- (void)recursivelyEnsureDisplay;

/**
 * @abstract Allows a node to bypass all ensureDisplay passes.  Defaults to NO.
 *
 * @discussion Nodes that are expensive to draw and expected to have placeholder even with
 * .neverShowPlaceholders enabled should set this to YES.
 *
 * ASImageNode uses the default of NO, as it is often used for UI images that are expected to synchronize with ensureDisplay.
 *
 * ASNetworkImageNode and ASMultiplexImageNode set this to YES, because they load data from a database or server,
 * and are expected to support a placeholder state given that display is often blocked on slow data fetching.
 */
@property (nonatomic, assign) BOOL shouldBypassEnsureDisplay;

@end

@interface UIView (ASDisplayNodeInternal)
@property (nonatomic, assign, readwrite) ASDisplayNode *asyncdisplaykit_node;
@end

@interface CALayer (ASDisplayNodeInternal)
@property (nonatomic, assign, readwrite) ASDisplayNode *asyncdisplaykit_node;
@end
