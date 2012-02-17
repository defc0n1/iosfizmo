/* FizmoGlkDelegate.h: Fizmo-specific delegate for the IosGlk library
 for IosFizmo, an IosGlk port of the Fizmo Z-machine interpreter.
 Designed by Andrew Plotkin <erkyrath@eblong.com>
 http://eblong.com/zarf/glk/
 */

#import <Foundation/Foundation.h>
#import "IosGlkLibDelegate.h"

@interface FizmoGlkDelegate : NSObject <IosGlkLibDelegate> {
	CGFloat maxwidth;
}

@property (nonatomic) CGFloat maxwidth;

@end