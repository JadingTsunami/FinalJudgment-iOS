/*
 
 Copyright (C) 2009-2011 id Software LLC, a ZeniMax Media company. 
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 
 */

#import "CreditsMenuViewController.h"
#include "doomiphone.h"
#include "iphone_delegate.h"

@implementation Doom_CreditsMenuViewController

/*
 ========================
 Doom_CreditsMenuViewController::initWithNibName
 ========================
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
                
    }
    return self;
}

/*
 ========================
 Doom_CreditsMenuViewController::didReceiveMemoryWarning
 ========================
 */
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 ========================
 Doom_CreditsMenuViewController::viewDidLoad
 ========================
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if( scrollView != nil ) {
        
        [self updateWadLabels];
        
        [self updatePwadList];
        
    }
}

- (void)updateWadLabels {
    iwadLabel.text = [NSString stringWithUTF8String:Cvar_VariableString("iwadSelection")];
    NSString *pwadfile = [[NSString stringWithUTF8String:Cvar_VariableString("pwadSelection")] lastPathComponent];
    pwadLabel.text = pwadfile;
}

- (void)updatePwadList {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *dirFiles = [filemgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    UIButton *button;
    int y = 5;
    for (id dir in dirFiles) {
        
        NSString *value = (NSString *)dir;
        
        if ([[value pathExtension] caseInsensitiveCompare:@"wad"]==NSOrderedSame){
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(pwadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:value forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        
            button.frame = CGRectMake(15, y, 270, 22.0);
            [pwadScroller addSubview:button];
            y += 25;
        }
    }
    
    [pwadScroller setContentSize:CGSizeMake(
                                            pwadScroller.bounds.size.width,
                                            CGRectGetMaxY(button.frame)
                                            )];

}

/*
 ========================
 Doom_CreditsMenuViewController::viewDidUnload
 ========================
 */
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*
 ========================
 Doom_CreditsMenuViewController::BackToMain
 ========================
 */
- (IBAction) BackToMain {
    
    [self.navigationController popViewControllerAnimated:NO];
    Sound_StartLocalSound( "iphone/controller_down_01_SILENCE.wav" );
}


- (IBAction)loadDoomIwad:(id)sender {
    
    iphoneWadSelect("doom.wad",NULL);
    [self updateWadLabels];

}

- (IBAction)loadDoom2Iwad:(id)sender {
    
    iphoneWadSelect("doom2.wad",NULL);
    [self updateWadLabels];
    
}

- (IBAction)loadTNTIwad:(id)sender {
    
    iphoneWadSelect("tnt.wad",NULL);
    [self updateWadLabels];
    
}

- (IBAction)loadPlutoniaIwad:(id)sender {
    
    iphoneWadSelect("plutonia.wad",NULL);
    [self updateWadLabels];
    
}

- (IBAction)xmasPwadOn:(id)sender {
    
    const char* iwad = Cvar_VariableString("iwadSelection");
    iphoneWadSelect(iwad,"spritx.wad");
    [self updateWadLabels];

}

- (IBAction)xmasPwadOff:(id)sender {
    
    const char* iwad = Cvar_VariableString("iwadSelection");
    iphoneWadSelect(iwad,"");
    [self updateWadLabels];

}

- (IBAction)pwadButtonPressed:(id)sender {
    const char* iwad = Cvar_VariableString("iwadSelection");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString* full_pwad = [NSString pathWithComponents:[NSArray arrayWithObjects:documentsDirectory,[[(UIButton*)sender titleLabel] text], nil]];
    printf("PWAD: %s\n", [full_pwad UTF8String]);
    iphoneWadSelect(iwad,[full_pwad UTF8String]);
    [self updateWadLabels];
}

- (void)dealloc {
    [pwadLabel release];
    [iwadLabel release];
    [super dealloc];
}
@end
