#import "tweak.h"


NSString* freeStorage();



//{"kPreferencesQuickActionURL":"prefs:root=Bluetooth"}

%hook SBUIAppIconForceTouchControllerDataProvider

-(NSArray *)applicationShortcutItems {

	NSString *bundleIdentifier = [self applicationBundleIdentifier];
	if (!bundleIdentifier) return %orig;
	if (![bundleIdentifier isEqualToString:@"com.apple.Preferences"]) return %orig;

	NSMutableArray *orig = [%orig mutableCopy];
	if (!orig) orig = [NSMutableArray new];

	SBSApplicationShortcutItem *item = [[%c(SBSApplicationShortcutItem) alloc] init];
	item.localizedTitle = @"Free Storage";
	item.localizedSubtitle = freeStorage();
	item.userInfo = @{@"kPreferencesQuickActionURL":@"prefs:root=General&path=STORAGE_MGMT"};

	item.bundleIdentifierToLaunch = bundleIdentifier;
	item.type = @"Storage3DType";
	[orig addObject:item];
	return orig;
}

%end

%hook SBUIAction

-(id)initWithTitle:(id)title subtitle:(id)arg2 image:(id)image badgeView:(id)arg4 handler:(id)arg5 {
	if ([title isEqualToString:@"Free Storage"]) {
		image = [[UIImage imageWithContentsOfFile:@"/Library/Application Support/Storage3D/storage3d.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	}
	
	return %orig;
}

%end


#define IS_IOS11orHIGHER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)



NSString* freeStorage() {
	
	if (IS_IOS11orHIGHER) {
		#pragma clang diagnostic push
		#pragma clang diagnostic ignored "-Wunguarded-availability-new"
	// i'm using /private/var/ with this func bc it's the only way to get accurate storage info and it's the same as reported by the settings app
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:@"/private/var/"];
		NSError *error = nil;
		NSDictionary *results = [fileURL resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey] error:&error];
		if (!results) {
			NSLog(@"Error retrieving resource keys: %@\n%@", [error localizedDescription], [error userInfo]);
		    return @"Error";
		}
		//NSLog(@"Available capacity for important usage: %@", );
		NSString *freeSpace = [NSByteCountFormatter stringFromByteCount:[results[NSURLVolumeAvailableCapacityForImportantUsageKey] longLongValue] countStyle:NSByteCountFormatterCountStyleFile];
		
		return freeSpace;
		
		#pragma clang diagnostic pop
		
	} else {
	
	
		NSDictionary *fattributes = [[NSDictionary alloc] init];
		
		
		fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:@"/private/var/" error:nil];
		
		//NSNumber *tot = [fattributes objectForKey:NSFileSystemSize];
		NSNumber *fure = [fattributes objectForKey:NSFileSystemFreeSize];
		
		//NSNumber *usedd = [NSNumber numberWithFloat:([tot floatValue] - [fure floatValue])];
		
		NSString *forFure = [NSByteCountFormatter stringFromByteCount:[fure longLongValue] countStyle:NSByteCountFormatterCountStyleFile];
		
		//NSString *forUsedd = [NSByteCountFormatter stringFromByteCount:[usedd longLongValue] countStyle:NSByteCountFormatterCountStyleFile];
		     
		
		
		
		//printf("Used: %s\nFree: %s\n",forUsedd.UTF8String, forFure.UTF8String);
		return forFure;
		
	}
}

