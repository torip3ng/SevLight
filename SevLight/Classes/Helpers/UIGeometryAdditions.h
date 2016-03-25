//
//  UIGeometryAdditions.h
//  iGlobe
//
//  Created by Yaroslav Bulda on 10/7/14.
//  Copyright (c) 2014 iGlobe. All rights reserved.
//

UIKIT_STATIC_INLINE UIEdgeInsets UIEdgeInsetsSetTop(UIEdgeInsets insets, CGFloat top) {
    UIEdgeInsets result = {top, insets.left, insets.bottom, insets.right};
    return result;
}

UIKIT_STATIC_INLINE UIEdgeInsets UIEdgeInsetsSetBottom(UIEdgeInsets insets, CGFloat bottom) {
    UIEdgeInsets result = {insets.top, insets.left, bottom, insets.right};
    return result;
}
