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

#import "ControlsMenuViewController.h"
#include "doomiphone.h"
#include "iphone_delegate.h"

/*
 ================================================================================================
 CreditsMenuViewController
 
 ================================================================================================
 */
@implementation Doom_ControlsMenuViewController

/*
 ========================
 Doom_ControlsMenuViewController::Initialize
 ========================
 */
- (void) Initialize {
    
    
    // Minimum track image setup.
	UIImage* minimumTrackImage = [UIImage imageNamed:@"SliderBar.png"];
	NSInteger minimumTrackImageCap = (NSInteger)(minimumTrackImage.size.width * 0.5f);
    
	UIImage* minimumTrackImageCapped = [minimumTrackImage stretchableImageWithLeftCapWidth:minimumTrackImageCap topCapHeight: 0];
    
    
	// Maximum track image setup.
	UIImage* maximumTrackImage = [UIImage imageNamed:@"SliderBackground.png"];
	NSInteger maximumTrackImageCap = (NSInteger)(maximumTrackImage.size.width * 0.5f);
    
	UIImage* maximumTrackImageCapped = [maximumTrackImage stretchableImageWithLeftCapWidth:maximumTrackImageCap topCapHeight: 0];
    
	// Thumb image.
	UIImage* thumbImage = [UIImage imageNamed:@"SliderSkull.png"];
    
	// Set up slider instances.
	[self SetupSlider:movestickSize minimumTrack:minimumTrackImageCapped
         maximumTrack:maximumTrackImageCapped
                thumb:thumbImage];
    
    
	[self SetupSlider:turnstickSize minimumTrack:minimumTrackImageCapped
         maximumTrack:maximumTrackImageCapped
                thumb:thumbImage];
    
    movestickSize.value = stickMove->value / 255;
    turnstickSize.value = stickTurn->value / 255;
    
    [singleThumbButton setImage:[UIImage imageNamed:@"LayoutSingleButton_Highlighted.png"] forState:UIControlStateDisabled];
    [dualThumbButton setImage:[UIImage imageNamed:@"LayoutDualButton_Highlighted.png"] forState:UIControlStateDisabled];
    [dirWheelButton setImage:[UIImage imageNamed:@"LayoutWheelButton_Highlighted.png"] forState:UIControlStateDisabled];
    
    if( controlScheme->value == 0 ) {
        singleThumbButton.enabled = NO;
        dualThumbButton.enabled = YES;
        dirWheelButton.enabled = YES;
    } else if( controlScheme->value == 1 ) {
        singleThumbButton.enabled = YES;
        dualThumbButton.enabled = NO;
        dirWheelButton.enabled = YES;
    } else if( controlScheme->value == 2 ) {
        singleThumbButton.enabled = YES;
        dualThumbButton.enabled = YES;
        dirWheelButton.enabled = NO;
    }
    
}

/*
 ========================
 Doom_ControlsMenuViewController::initWithNibName
 ========================
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
 ========================
 Doom_ControlsMenuViewController::didReceiveMemoryWarning
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
 Doom_ControlsMenuViewController::viewDidLoad
 ========================
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [ self Initialize ];
}

/*
 ========================
 Doom_ControlsMenuViewController::SetupSlider
 ========================
 */
- (void) SetupSlider:(UISlider*)slider minimumTrack:(UIImage*) __unused minImage
        maximumTrack:(UIImage*) __unused maxImage
               thumb:(UIImage*)thumbImage {
	
	//[slider setMinimumTrackImage:minImage forState:UIControlStateNormal];
	//slider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    
	[slider setThumbImage:thumbImage forState:UIControlStateNormal];
	[slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
}

/*
 ========================
 Doom_ControlsMenuViewController::BackToMain
 ========================
 */
- (IBAction) BackToMain {
    
    [self.navigationController popViewControllerAnimated:NO];
    Sound_StartLocalSound( "iphone/controller_down_01_SILENCE.wav" );
}

/*
 ========================
 Doom_ControlsMenuViewController::HudLayoutPressed
 ========================
 */
- (IBAction) HudLayoutPressed {
    
     menuState = IPM_HUDEDIT;
     HudEditFrame();
    [gAppDelegate ShowGLView ];
}

/*
 ========================
 Doom_ControlsMenuViewController::SingleThumbpadPressed
 ========================
 */
- (IBAction) SingleThumbpadPressed {
    
    Cvar_SetValue( controlScheme->name, 0 );
    HudSetForScheme( 0 );
    
    if( controlScheme->value == 0 ) {
        singleThumbButton.enabled = NO;
        dualThumbButton.enabled = YES;
        dirWheelButton.enabled = YES;
    } else if( controlScheme->value == 1 ) {
        singleThumbButton.enabled = YES;
        dualThumbButton.enabled = NO;
        dirWheelButton.enabled = YES;
    } else if( controlScheme->value == 2 ) {
        singleThumbButton.enabled = YES;
        dualThumbButton.enabled = YES;
        dirWheelButton.enabled = NO;
    }
    
}

/*
 ========================
 Doom_ControlsMenuViewController::DualThumbpadPressed
 ========================
 */
- (IBAction) DualThumbpadPressed {
    
    Cvar_SetValue( controlScheme->name, 1 );
    HudSetForScheme( 1 );
    
    if( controlScheme->value == 0 ) {
        singleThumbButton.enabled = NO;
        dualThumbButton.enabled = YES;
        dirWheelButton.enabled = YES;
    } else if( controlScheme->value == 1 ) {
        singleThumbButton.enabled = YES;
        dualThumbButton.enabled = NO;
        dirWheelButton.enabled = YES;
    } else if( controlScheme->value == 2 ) {
        singleThumbButton.enabled = YES;
        dualThumbButton.enabled = YES;
        dirWheelButton.enabled = NO;
    }
}

/*
 ========================
 Doom_ControlsMenuViewController::DirWheelPressed
 ========================
 */
- (IBAction) DirWheelPressed {
    
    Cvar_SetValue( controlScheme->name, 2 );
    HudSetForScheme( 2 );
    
    if( controlScheme->value == 0 ) {
        singleThumbButton.enabled = NO;
        dualThumbButton.enabled = YES;
        dirWheelButton.enabled = YES;
    } else if( controlScheme->value == 1 ) {
        singleThumbButton.enabled = YES;
        dualThumbButton.enabled = NO;
        dirWheelButton.enabled = YES;
    } else if( controlScheme->value == 2 ) {
        singleThumbButton.enabled = YES;
        dualThumbButton.enabled = YES;
        dirWheelButton.enabled = NO;
    }
}

/*
 ========================
 Doom_ControlsMenuViewController::MoveStickValChanged
 ========================
 */
- (IBAction) MoveStickValChanged {
    
    Cvar_SetValue( stickMove->name, movestickSize.value * 256.0f );
    
}

/*
 ========================
 Doom_ControlsMenuViewController::TurnStickValChanged
 ========================
 */
- (IBAction) TurnStickValChanged {
    
    Cvar_SetValue( stickTurn->name, turnstickSize.value * 256.0f );
}

@end
