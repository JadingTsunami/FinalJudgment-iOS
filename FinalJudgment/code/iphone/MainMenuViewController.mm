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

#import "MainMenuViewController.h"
#include "iphone_delegate.h"
#include "doomiphone.h"
#import "CreditsMenuViewController.h"
#import "SettingsMenuViewController.h"
#import "ControlsMenuViewController.h"
#import "LegalMenuViewController.h"

/*
 ================================================================================================
 Doom Sub Menu Banner Interface object
 ================================================================================================
 */

@implementation Banner_SubItem
@end

@implementation Banner_SubMenu

/*
 ========================
 Banner_SubMenu::awakeFromNib
 ========================
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    isHidden = YES;
    
    if( !didInit ) {
        char full_iwad[PATH_MAX];
                
        I_FindFile( doom_iwad, ".wad", full_iwad );
        
        // fall back to default DOOM wad
        if( full_iwad[0] == '\0' ) {
            I_FindFile( DEFAULT_IWAD, ".wad", full_iwad );
            if( doom_iwad ) free(doom_iwad);
            doom_iwad = strdup(full_iwad);
        } else if( strcmp(doom_iwad,full_iwad) != 0 ) {
            if( doom_iwad ) free(doom_iwad);
            doom_iwad = strdup( full_iwad );
        }
        
        iphoneDoomStartup();
        didInit = YES;
    }
}

/*
 ========================
 Banner_SubMenu::hitTest
 ========================
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (hitView != self) {
        return hitView;
    }
    
    return nil;
}

/*
 ========================
 Banner_SubMenu::Hide
 ========================
 */
- (void) Hide {
    
    if( !isHidden ) {
        
        isHidden = YES;
        
        [UIView beginAnimations:@"Show" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationBeginsFromCurrentState:NO];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(Disable)];
        
        self.alpha = 1.0f;
        [ self viewWithTag: 0 ].alpha = 0.0f;
        
        [UIView commitAnimations];
        
    }
}

/*
 ========================
 Banner_SubMenu::Show
 ========================
 */
- (void) Show {
    
    if( isHidden ) {
        
        isHidden = NO;
        
        [UIView beginAnimations:@"Show" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationBeginsFromCurrentState:NO];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(Enable)];
        
        self.alpha = 1.0f;
        [ self viewWithTag: 0 ].alpha = 1.0f;
        
        [UIView commitAnimations];
    }
}

@end


/*
 ================================================================================================
 MainMenuViewController
 ================================================================================================
 */
@implementation Doom_MainMenuViewController

/*
 ========================
 MainMenuViewController::initWithNibName
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
 MainMenuViewController::didReceiveMemoryWarning
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
 MainMenuViewController::viewDidLoad
 ========================
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
 ========================
 MainMenuViewController::ResumeGamePressed
 ========================
 */
- (IBAction) ResumeGamePressed {
    
    [ gAppDelegate ShowGLView ];
    
    ResumeGame();
    
    Sound_StartLocalSound( "iphone/baborted_01.wav" );
 
}

/*
 ========================
 MainMenuViewController::CreditsPressed
 ========================
 */
- (IBAction) CreditsPressed {
    
    Doom_CreditsMenuViewController *vc = nil;
	

    vc = [[Doom_CreditsMenuViewController alloc] initWithNibName:@"CreditsMenuView" bundle:nil];
	
    [self.navigationController pushViewController:vc animated:NO];
    [vc release];
    
    Sound_StartLocalSound( "iphone/baborted_01.wav" );
}

/*
 ========================
 MainMenuViewController::LegalPressed
 ========================
 */
- (IBAction) LegalPressed {
    
    Doom_LegalMenuViewController *vc = nil;
	

    vc = [[Doom_LegalMenuViewController alloc] initWithNibName:@"LegalMenuView" bundle:nil];
	
	
    [self.navigationController pushViewController:vc animated:NO];
    [vc release];
    
    Sound_StartLocalSound( "iphone/baborted_01.wav" );
}

/*
 ========================
 MainMenuViewController::ControlsOptionsPressed
 ========================
 */
- (IBAction) ControlsOptionsPressed {
    
    Doom_ControlsMenuViewController *vc = nil;
	
    vc = [[Doom_ControlsMenuViewController alloc] initWithNibName:@"ControlsMenuView" bundle:nil];
	
    [self.navigationController pushViewController:vc animated:NO];
    [vc release];

    Sound_StartLocalSound( "iphone/baborted_01.wav" );
    
}

/*
 ========================
 MainMenuViewController::SettingsOptionsPressed
 ========================
 */
- (IBAction) SettingsOptionsPressed {
    

	Doom_SettingsMenuViewController *vc = nil;
	
    vc = [[Doom_SettingsMenuViewController alloc] initWithNibName:@"SettingsMenuView" bundle:nil];
	
     [self.navigationController pushViewController:vc animated:NO];
     [vc release];
    
    Sound_StartLocalSound( "iphone/baborted_01.wav" );
}

@end
