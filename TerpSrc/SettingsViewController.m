/* SettingsViewController.h: Interpreter settings tab view controller
 for IosFizmo, an IosGlk port of the Fizmo Z-machine interpreter.
 Designed by Andrew Plotkin <erkyrath@eblong.com>
 http://eblong.com/zarf/glk/
 */

#import "SettingsViewController.h"
#import "FizmoGlkViewController.h"
#import "DisplayWebViewController.h"

@implementation SettingsViewController

@synthesize tableview;
@synthesize autocorrectcell;
@synthesize morepromptcell;
@synthesize licensecell;
@synthesize autocorrectswitch;
@synthesize morepromptswitch;

- (void) dealloc {
	self.tableview = nil;
	self.autocorrectcell = nil;
	self.morepromptcell = nil;
	self.licensecell = nil;
	self.autocorrectswitch = nil;
	self.morepromptswitch = nil;
	[super dealloc];
}

- (void) viewDidLoad
{
	NSLog(@"SettingsVC: viewDidLoad");

	if ([tableview respondsToSelector:@selector(backgroundView)]) {
		/* This is only available in iOS 3.2 and up */
		tableview.backgroundView = [[[UIView alloc] initWithFrame:tableview.backgroundView.frame] autorelease];
		tableview.backgroundView.backgroundColor = [UIColor colorWithRed:0.85 green:0.8 blue:0.6 alpha:1];
	}
		
	if ([tableview respondsToSelector:@selector(addGestureRecognizer:)]) {
		/* gestures are available in iOS 3.2 and up */
		
		FizmoGlkViewController *mainviewc = [FizmoGlkViewController singleton];
		UISwipeGestureRecognizer *recognizer;
		recognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:mainviewc action:@selector(handleSwipeLeft:)] autorelease];
		recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
		[tableview addGestureRecognizer:recognizer];
		recognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:mainviewc action:@selector(handleSwipeRight:)] autorelease];
		recognizer.direction = UISwipeGestureRecognizerDirectionRight;
		[tableview addGestureRecognizer:recognizer];
	}
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	IosGlkViewController *glkviewc = [IosGlkViewController singleton];
	return [glkviewc shouldAutorotateToInterfaceOrientation:orientation];
}

- (void) handleLicenses
{
	NSString *title = NSLocalizedStringFromTable(@"settings.title.license", @"TerpLocalize", nil);
	DisplayWebViewController *viewc = [[[DisplayWebViewController alloc] initWithNibName:@"WebDocVC" filename:@"license" title:title bundle:nil] autorelease];
	[self.navigationController pushViewController:viewc animated:YES];
}

/* UITableViewDataSource methods */

#define SECTION_PREFS (0)
#define SECTION_LICENSE (1)
#define NUM_SECTIONS (2)

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return NUM_SECTIONS;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == SECTION_PREFS)
		return NSLocalizedStringFromTable(@"settings.section.settings", @"TerpLocalize", nil);
	return nil;
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return nil;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case SECTION_PREFS:
			return 2;
		case SECTION_LICENSE:
			return 1;
		default:
			return 0;
	}
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexpath
{
	switch (indexpath.section) {
		case SECTION_PREFS:
			switch (indexpath.row) {
				case 0:
					return autocorrectcell;
				case 1:
					return morepromptcell;
				default:
					return nil;
			}
			
		case SECTION_LICENSE:
			switch (indexpath.row) {
				case 0:
					return licensecell;
				default:
					return nil;
			}
			
		default:
			return nil;
	}
}

/* UITableViewDelegate methods */

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexpath
{
	[tableview deselectRowAtIndexPath:indexpath animated:NO];
	if (indexpath.section == SECTION_LICENSE && indexpath.row == 0)
		[self handleLicenses];
}


@end