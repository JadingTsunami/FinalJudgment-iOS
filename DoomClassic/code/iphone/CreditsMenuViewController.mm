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
        
        [scrollView setContentSize:CGSizeMake(
                                              scrollView.bounds.size.width,
                                              CGRectGetMaxY(lastItem.frame)
                                              )];
    }
}

- (void)updateWadLabels {
    iwadLabel.text = [NSString stringWithUTF8String:Cvar_VariableString("iwadSelection")];
    pwadLabel.text = [NSString stringWithUTF8String:Cvar_VariableString("pwadSelection")];
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


- (void)dealloc {
    [pwadLabel release];
    [iwadLabel release];
    [super dealloc];
}
@end
