
@class SBSApplicationShortcutIcon;

@interface SBSApplicationShortcutItem : NSObject <NSCopying>

@property (nonatomic,copy) NSString * type;
@property (nonatomic,copy) NSString * localizedTitle;
@property (nonatomic,copy) NSString * localizedSubtitle;
@property (nonatomic,copy) NSString * bundleIdentifierToLaunch;
@property (nonatomic, copy) SBSApplicationShortcutIcon *icon;
@end

@interface SBUIAppIconForceTouchControllerDataProvider : NSObject

-(NSString *)applicationBundleIdentifier;

@end