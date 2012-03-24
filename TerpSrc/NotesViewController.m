/* NotesViewController.m: Interpreter notes tab view controller
 for IosFizmo, an IosGlk port of the Fizmo Z-machine interpreter.
 Designed by Andrew Plotkin <erkyrath@eblong.com>
 http://eblong.com/zarf/glk/
 */

#import "NotesViewController.h"
#import "IosGlkViewController.h"
#import "TranscriptViewController.h"

#define NOTES_SAVE_DELAY (60)

@implementation NotesViewController

@synthesize textview;
@synthesize notespath;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
	}
	return self;
}

- (void) dealloc {
	self.textview = nil;
	[super dealloc];
}

- (void) viewDidLoad
{
	NSLog(@"NotesVC: viewDidLoad");
	
	textview.delegate = self;
	
	//### bang on font if Noteworthy is not available
	UIImage *stripeimg = nil;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
		stripeimg = [UIImage imageNamed:@"background-notes-s"];
	else
		stripeimg = [UIImage imageNamed:@"background-notes"];
	textview.backgroundColor = [UIColor colorWithPatternImage:stripeimg];
	
	/* We use an old-fashioned way of locating the Documents directory. (The NSManager method for this is iOS 4.0 and later.) */
	
	if (!notespath) {
		NSArray *dirlist = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		if (dirlist.count) {
			NSString *dir = [dirlist objectAtIndex:0];
			self.notespath = [dir stringByAppendingPathComponent:@"PlayerNotes.txt"];
		}
	}
	
	textchanged = NO;
	
	if (notespath) {
		NSString *str = [NSString stringWithContentsOfFile:notespath encoding:NSUTF8StringEncoding error:nil];
		if (str)
			textview.text = str;
	}

	if ([textview respondsToSelector:@selector(addGestureRecognizer:)]) {
		/* gestures are available in iOS 3.2 and up */
		UISwipeGestureRecognizer *recognizer;
		recognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)] autorelease];
		recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
		[textview addGestureRecognizer:recognizer];
		recognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)] autorelease];
		recognizer.direction = UISwipeGestureRecognizerDirectionRight;
		[textview addGestureRecognizer:recognizer];
	}
}

- (void) viewWillUnload
{
	NSLog(@"NotesVC: viewWillUnload");
	[self saveIfNeeded];
	textview.delegate = nil;
}

/* Called both when you leave the Notes tab, and when the notes view is covered by a pushed transcript view.
 */
- (void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self saveIfNeeded];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self adjustToKeyboardBox];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	IosGlkViewController *glkviewc = [IosGlkViewController singleton];
	return [glkviewc shouldAutorotateToInterfaceOrientation:orientation];
}

- (IBAction) toggleKeyboard
{
	if ([textview isFirstResponder]) {
		[textview resignFirstResponder];
	}
	else {
		[textview becomeFirstResponder];
	}
}

- (void) adjustToKeyboardBox {
	CGRect keyboardbox = [IosGlkViewController singleton].keyboardbox;
	/* This rect is in window coordinates. */
	
	if (textview) {
		CGFloat offset = 0;
		
		if (keyboardbox.size.width > 0 && keyboardbox.size.height > 0) {
			CGRect box = textview.bounds;
			CGFloat bottom = box.origin.y + box.size.height;
			CGRect rect = [textview convertRect:keyboardbox fromView:nil];
			if (rect.origin.y < bottom) {
				offset = bottom - rect.origin.y;
			}
		}
		
		UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, offset, 0);
		textview.contentInset = insets;
		textview.scrollIndicatorInsets = insets;
	}
}

- (IBAction) handleTranscripts
{
	TranscriptViewController *transviewc = [[[TranscriptViewController alloc] initWithNibName:@"TranscriptVC" bundle:nil] autorelease];
	[self.navigationController pushViewController:transviewc animated:YES];
}

- (void) saveIfNeeded
{
	if (!textchanged)
		return;
	NSLog(@"NotesVC: saving notes");
	textchanged = NO;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(saveIfNeeded) object:nil];
	if (notespath && textview.text) {
		[textview.text writeToFile:notespath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	}
}

- (void) handleSwipeLeft:(UIGestureRecognizer *)recognizer {
	if (self.tabBarController) {
		self.tabBarController.selectedIndex = 2;
	}
}

- (void) handleSwipeRight:(UIGestureRecognizer *)recognizer {
	if (self.tabBarController) {
		self.tabBarController.selectedIndex = 0;
	}
}

/* UITextView delegate method */

- (void) textViewDidChange:(UITextView *)textView
{
	if (!textchanged) {
		textchanged = YES;
		[self performSelector:@selector(saveIfNeeded) withObject:nil afterDelay:NOTES_SAVE_DELAY];
	}
}

@end

