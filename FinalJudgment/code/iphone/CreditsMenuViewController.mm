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
#include <stdio.h>

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
    
    doomEpisodes = [[NSArray alloc] initWithObjects:@"E1", @"E2", @"E3", @"E4",nil ];
    doomLevels = [[NSArray alloc] initWithObjects:@"M1", @"M2", @"M3", @"M4", @"M5", @"M6", @"M7", @"M8", @"M9", nil ];
    
    episodicIWADs = [[NSArray alloc] initWithObjects:
                     @"freedoom.wad",
                     @"freedoom1.wad",
                     @"freedoomu.wad",
                     @"doom.wad",
                     @"udoom.wad",
                     @"doomu.wad",
                     @"bfgdoom.wad",
                     @"doombfg.wad",
                     @"doom1.wad",
                     @"chex.wad",
                     @"chex2.wad",
                     @"chex3.wad",
                     nil];
    
    builtinIWADs = [[NSArray alloc] initWithObjects:
                    @"doom.wad",
                    @"doom2.wad",
                    @"tnt.wad",
                    @"plutonia.wad",
                    nil];
    
    doom2Levels = [[NSArray alloc] initWithObjects:
                    @"MAP01",
                    @"MAP02",
                    @"MAP03",
                    @"MAP04",
                    @"MAP05",
                    @"MAP06",
                    @"MAP07",
                    @"MAP08",
                    @"MAP09",
                    @"MAP10",
                    @"MAP11",
                    @"MAP12",
                    @"MAP13",
                    @"MAP14",
                    @"MAP15",
                    @"MAP16",
                    @"MAP17",
                    @"MAP18",
                    @"MAP19",
                    @"MAP20",
                    @"MAP21",
                    @"MAP22",
                    @"MAP23",
                    @"MAP24",
                    @"MAP25",
                    @"MAP26",
                    @"MAP27",
                    @"MAP28",
                    @"MAP29",
                    @"MAP30",
                    @"MAP31",
                    @"MAP32",
                   nil
                    ];
    
    skillLevels = [[NSArray alloc] initWithObjects:
                    @"Easy",
                    @"Medium",
                    @"Hard",
                    @"Fatal!",
                    nil
                   ];
    
    /* for first start, set up some defaults */
    if(!doom_iwad) doom_iwad = strdup(DEFAULT_IWAD);
    if(!doom_pwads) doom_pwads = strdup("");
    
    /* check if our IWAD is episodic */
    episodic = [episodicIWADs containsObject: [[[NSString stringWithUTF8String:doom_iwad] lastPathComponent] lowercaseString]];
    
    [self updateWadLabels];
    [self updateWadList];
    
    [pwadView removeFromSuperview];
    [iwadView removeFromSuperview];

    self->skillPicker.dataSource = self;
    self->skillPicker.delegate = self;
    
    self->levelPicker.dataSource = self;
    self->levelPicker.delegate = self;

}

- (void)updateWadLabels {
    
    [levelPicker reloadAllComponents];
    [levelPicker selectRow:0 inComponent:0 animated:NO];
}

- (void)updateWadList {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *dirFiles = [filemgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    int pwadOffset = 5;
    int iwadOffset = 5;
    
    /* add built-in IWADs first */
    for(id biwad in builtinIWADs) {
        [self addWAD:biwad wadScroller:iwadScroller offset:iwadOffset iwad:true];
        iwadOffset += 25;
    }
    
    for (id dir in dirFiles) {
        
        NSString *value = (NSString *)dir;
        
        if ([[value pathExtension] caseInsensitiveCompare:@"wad"]==NSOrderedSame){
            /* Sort out IWADs */
            NSString *path = [documentsDirectory stringByAppendingPathComponent:value];
            
            FILE *f = fopen([path UTF8String],"r");
            
            char wadtype[4];
            if( f && fread( wadtype, sizeof(char), 4, f ) ) {
                if ( memcmp( "IWAD", &wadtype, sizeof(char)*4 ) == 0 ) {
                    /* found an IWAD */
                    [self addWAD:value wadScroller:iwadScroller offset:iwadOffset iwad:true];
                    iwadOffset += 25;
                } else if ( memcmp( "PWAD", &wadtype, sizeof(char)*4 ) == 0 ) {
                    /* PWAD, keep going */
                    [self addWAD:value wadScroller:pwadScroller offset:pwadOffset iwad:false];
                    pwadOffset += 25;
                } else {
                    /* neither IWAD nor PWAD; skip */
                    NSLog(@"Did not recognize the WAD: %@",value);
                }
                fclose(f);
            } else {
                NSLog(@"Failed to open: %@; %d",value, errno);
            }
        }
    }
}

- (void)addWAD:(NSString*)wad wadScroller:(UIScrollView*)scroller offset:(int) y iwad:(bool) isIWAD {
    
    UIButton *button = NULL;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    if( isIWAD ) {
        [button addTarget:self action:@selector(iwadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [button addTarget:self action:@selector(pwadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    [button setTitle:wad forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    
    if( !isIWAD && doom_pwads ) {
        /* check if the PWAD is in the list */
        for ( NSString* str in [[NSString stringWithUTF8String:doom_pwads] componentsSeparatedByString:[NSString stringWithFormat:@"%c", PWAD_LIST_SEPARATOR]] ) {
            if( [str caseInsensitiveCompare:wad] == NSOrderedSame ) {
                [button setSelected:(YES)];
                break;
            }
        }
    } else if ( [[[NSString stringWithUTF8String:doom_iwad] lastPathComponent] compare:wad options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            [button setSelected:(YES)];
    }
    button.frame = CGRectMake(15, y, ((float)scroller.bounds.size.width)-15.0, 22.0);

    [scroller addSubview:button];

    if( button ) {
        [scroller setContentSize:CGSizeMake(
                                                scroller.bounds.size.width,
                                                CGRectGetMaxY(button.frame)
                                                )];
    }
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

- (IBAction)clearPWADs:(id) __unused sender {
    
    iphoneClearPWADs();
    
    if ([[pwadScroller subviews] count] > 0) {
        for( UIView* subview in [pwadScroller subviews]) {
            if ([subview isKindOfClass:[UIButton class]]) {
                [(UIButton*)subview setSelected:NO];
            }
        }
    }
    [self updateWadLabels];

}

- (IBAction)pwadButtonPressed:(id)sender {
/*
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
*/
    NSString* full_pwad = [[(UIButton*)sender titleLabel] text];
    
    if( [(UIButton*)sender isSelected]) {
        /*NSString* full_pwad = [NSString pathWithComponents:[NSArray arrayWithObjects:documentsDirectory,[[(UIButton*)sender titleLabel] text], nil]];*/
        [(UIButton*)sender setSelected:NO];
        printf("PWAD: %s\n", [full_pwad UTF8String]);
        iphonePWADRemove([full_pwad UTF8String]);
    } else {
        [(UIButton*)sender setSelected:YES];
        printf("PWAD: %s\n", [full_pwad UTF8String]);
        iphonePWADAdd([full_pwad UTF8String]);
    }
    [self updateWadLabels];
}

- (IBAction)iwadButtonPressed:(id)sender {
    
    /* IWADs are single-selection only */
    if ([[iwadScroller subviews] count] > 0) {
        for( UIView* subview in [iwadScroller subviews]) {
            if ([subview isKindOfClass:[UIButton class]]) {
                [(UIButton*)subview setSelected:NO];
            }
        }
    }
    
    NSString *newIWAD = [[(UIButton*)sender titleLabel] text];
    
    episodic = [episodicIWADs containsObject: [newIWAD lowercaseString]];
    
    /* select the new IWAD */
    [(UIButton*)sender setSelected:YES];
    iphoneIWADSelect([newIWAD UTF8String]);
    
    [self updateWadLabels];
}

- (IBAction)playButtonPressed:(UIButton *) __unused sender {
    
    mapStart_t localStartmap;

    if( [levelPicker numberOfComponents] == 2) {
        localStartmap.episode = (int) ([levelPicker selectedRowInComponent:0] + 1);
        localStartmap.map = (int) ([levelPicker selectedRowInComponent:1] + 1);
    } else {
        localStartmap.episode = 1;
        localStartmap.map = (int) ([levelPicker selectedRowInComponent:0] + 1);
    }
    
    localStartmap.dataset = 0;
    localStartmap.skill = (int) [skillPicker selectedRowInComponent:0];

    // load our selected IWAD and PWADs
    iphoneDoomStartup();
    StartSinglePlayerGame( localStartmap );
    
    [ gAppDelegate ShowGLView ];
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   
    if( pickerView == levelPicker && episodic ) {
        return 2; // episode, map
    }
    
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
 
    if( pickerView == levelPicker ) {
        if( episodic ) {
            if( component == 0 ) {
                return (NSInteger) doomEpisodes.count;
            } else if( component == 1 ) {
                return (NSInteger) doomLevels.count;
            }
        } else {
            return (NSInteger) doom2Levels.count;
        }
    }
    
    if( pickerView == skillPicker ) {
        return (NSInteger) skillLevels.count;
    }
    
    return 1;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if( pickerView == levelPicker ) {
        if( episodic ) {
            if( component == 0 ) {
                return doomEpisodes[ (NSUInteger) row];
            } else if( component == 1 ) {
                return doomLevels[ (NSUInteger) row];
            }
        } else {
            return doom2Levels[ (NSUInteger) row];
        }
    }
    
    if( pickerView == skillPicker ) {
        return skillLevels[ (NSUInteger) row];
    }
    
    return nil;
}


- (void)dealloc {
    [levelPicker release];
    [skillPicker release];
    [iwadScroller release];
    [pwadView release];
    [iwadView release];
    [super dealloc];
}
@end
