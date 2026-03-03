#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "gh-logo" asset catalog image resource.
static NSString * const ACImageNameGhLogo AC_SWIFT_PRIVATE = @"gh-logo";

#undef AC_SWIFT_PRIVATE
