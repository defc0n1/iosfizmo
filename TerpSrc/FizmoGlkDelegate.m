/* FizmoGlkDelegate.m: Fizmo-specific delegate for the IosGlk library
 for IosFizmo, an IosGlk port of the Fizmo Z-machine interpreter.
 Designed by Andrew Plotkin <erkyrath@eblong.com>
 http://eblong.com/zarf/glk/
 */

#import "FizmoGlkDelegate.h"
#import "IosGlkLibDelegate.h"
#import "StyleSet.h"

@implementation FizmoGlkDelegate

@synthesize maxwidth;
@synthesize fontfamily;
@synthesize fontscale;
@synthesize colorscheme;

- (void) dealloc {
	self.fontfamily = nil;
	[super dealloc];
}

- (UIColor *) genForegroundColor {
	switch (colorscheme) {
		case 1: /* quiet */
			return [UIColor colorWithRed:0.2 green:0.15 blue:0.0 alpha:1];
		case 2: /* dark */
			return [UIColor colorWithRed:0.75 green:0.75 blue:0.7 alpha:1];
		case 0: /* bright */
		default:
			return [UIColor blackColor];
	}
}

- (UIColor *) genBackgroundColor {
	switch (colorscheme) {
		case 1: /* quiet */
			return [UIColor colorWithRed:0.9 green:0.85 blue:0.7 alpha:1];
		case 2: /* dark */
			return [UIColor blackColor];
		case 0: /* bright */
		default:
			return [UIColor colorWithRed:1 green:1 blue:0.95 alpha:1];
	}
}

- (void) prepareStyles:(StyleSet *)styles forWindowType:(glui32)wintype rock:(glui32)rock {
	BOOL isiphone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
	
	if (wintype == wintype_TextGrid) {
		styles.margins = UIEdgeInsetsMake(6, 6, 6, 6);
		
		CGFloat statusfontsize;
		if (isiphone) {
			statusfontsize = 9+fontscale;
		}
		else {
			statusfontsize = 11+fontscale;
		}
		
		FontVariants variants = [StyleSet fontVariantsForSize:statusfontsize name:@"Courier", nil];
		styles.fonts[style_Normal] = variants.normal;
		styles.fonts[style_Emphasized] = variants.italic;
		styles.fonts[style_Preformatted] = variants.normal;
		styles.fonts[style_Header] = variants.bold;
		styles.fonts[style_Subheader] = variants.bold;
		styles.fonts[style_Alert] = variants.italic;
		styles.fonts[style_Note] = variants.italic;
		
		switch (colorscheme) {
			case 1: /* quiet */
				styles.backgroundcolor = [UIColor colorWithRed:0.75 green:0.7 blue:0.6 alpha:1];
				styles.colors[style_Normal] = [UIColor colorWithRed:0.15 green:0.1 blue:0.0 alpha:1];
				break;
			case 2: /* dark */
				styles.backgroundcolor =  [UIColor colorWithRed:0.55 green:0.55 blue:0.5 alpha:1];
				styles.colors[style_Normal] = [UIColor blackColor];
				break;
			case 0: /* bright */
			default:
				styles.backgroundcolor = [UIColor colorWithRed:0.85 green:0.8 blue:0.6 alpha:1];
				styles.colors[style_Normal] = [UIColor colorWithRed:0.25 green:0.2 blue:0.0 alpha:1];
				break;
		}
	}
	else {
		styles.margins = UIEdgeInsetsMake(4, 6, 4, 6);

		CGFloat statusfontsize = 11+fontscale;

		FontVariants variants;
		if ([fontfamily isEqualToString:@"Helvetica"]) {
			variants = [StyleSet fontVariantsForSize:statusfontsize name:@"Helvetica Neue", @"Helvetica", nil];
		}
		else if ([fontfamily isEqualToString:@"Euphemia"]) {
			variants = [StyleSet fontVariantsForSize:statusfontsize name:@"EuphemiaUCAS", @"Verdana", nil];
		}
		else if (!fontfamily) {
			variants = [StyleSet fontVariantsForSize:statusfontsize name:@"Georgia", nil];
		}
		else {
			variants = [StyleSet fontVariantsForSize:statusfontsize name:fontfamily, @"Georgia", nil];
		}
		
		styles.fonts[style_Normal] = variants.normal;
		styles.fonts[style_Emphasized] = variants.italic;
		styles.fonts[style_Preformatted] = [UIFont fontWithName:@"Courier" size:14];
		styles.fonts[style_Header] = variants.bold;
		styles.fonts[style_Subheader] = variants.bold;
		styles.fonts[style_Input] = variants.bold;
		styles.fonts[style_Alert] = variants.italic;
		styles.fonts[style_Note] = variants.italic;
		
		styles.backgroundcolor = self.genBackgroundColor;
		styles.colors[style_Normal] = self.genForegroundColor;
	}
}

- (CGSize) interWindowSpacing {
	return CGSizeMake(2, 2);
}

- (CGRect) adjustFrame:(CGRect)rect {
	if (maxwidth > 64 && rect.size.width > maxwidth) {
		rect.origin.x = (rect.origin.x+0.5*rect.size.width) - 0.5*maxwidth;
		rect.size.width = maxwidth;
	}
	return rect;
}

@end

