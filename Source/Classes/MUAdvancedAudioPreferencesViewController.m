/* Copyright (C) 2009-2011 Mikkel Krautz <mikkel@krautz.dk>

   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   - Redistributions of source code must retain the above copyright notice,
     this list of conditions and the following disclaimer.
   - Redistributions in binary form must reproduce the above copyright notice,
     this list of conditions and the following disclaimer in the documentation
     and/or other materials provided with the distribution.
   - Neither the name of the Mumble Developers nor the names of its
     contributors may be used to endorse or promote products derived from this
     software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
   A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "MUAdvancedAudioPreferencesViewController.h"
#import "MUTableViewHeaderLabel.h"
#import "MUApplication.h"
#import "MUApplicationDelegate.h"
#import "MUAudioQualityPreferencesViewController.h"
#import "MUColor.h"

@implementation MUAdvancedAudioPreferencesViewController

- (id) init {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.title = @"Advanced Audio";
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundTextureBlackGradient"]] autorelease];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;

    [self.tableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (section == 0) {
        return 1 + ([defaults boolForKey:@"AudioPreprocessor"] ? 0 : 1);
    } else if (section == 1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MUAdvancedAudioPreferencesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([indexPath section] == 0) {
        if ([indexPath row] == 0) {
            cell.textLabel.text = @"Preprocessing";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *preprocSwitch = [[[UISwitch alloc] init] autorelease];
            preprocSwitch.onTintColor = [UIColor blackColor];
            preprocSwitch.on = [defaults boolForKey:@"AudioPreprocessor"];
            [preprocSwitch addTarget:self action:@selector(preprocessingChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = preprocSwitch;
        } else if ([indexPath row] == 1) {
            cell.textLabel.text = @"Mic Boost";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISlider *slider = [[[UISlider alloc] init] autorelease];
            [slider setMaximumValue:2.0f];
            [slider setMinimumValue:0.0f];
            float boost = [defaults floatForKey:@"AudioMicBoost"];
            if (boost > 1.0f) {
                [slider setMinimumTrackTintColor:[MUColor badPingColor]];
            } else {
                [slider setMinimumTrackTintColor:[MUColor goodPingColor]];
            }
            [slider setValue:boost];
            [slider addTarget:self action:@selector(micBoostChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = slider;
        }
    } else if ([indexPath section] == 1) {
        if ([indexPath row] == 0) {
            cell.textLabel.text = @"Quality";
            cell.detailTextLabel.textColor = [MUColor selectedTextColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if ([[defaults stringForKey:@"AudioQualityKind"] isEqualToString:@"low"])
                cell.detailTextLabel.text = @"Low";
            if ([[defaults stringForKey:@"AudioQualityKind"] isEqualToString:@"balanced"])
                cell.detailTextLabel.text = @"Balanced";
            if ([[defaults stringForKey:@"AudioQualityKind"] isEqualToString:@"high"])
                cell.detailTextLabel.text = @"High";
            if ([[defaults stringForKey:@"AudioQualityKind"] isEqualToString:@"custom"])
                cell.detailTextLabel.text = @"Custom";
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) { // Input
        return [MUTableViewHeaderLabel labelWithText:@"Audio Input"];
    } else if (section == 1) {
        return [MUTableViewHeaderLabel labelWithText:@"Transmission Quality"];
    } else {
        return nil;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [MUTableViewHeaderLabel defaultHeaderHeight];
    } else if (section == 1) {
        return [MUTableViewHeaderLabel defaultHeaderHeight];
    }
    return 0.0f;
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 1 && [indexPath row] == 0) {
        MUAudioQualityPreferencesViewController *audioQual = [[MUAudioQualityPreferencesViewController alloc] init];
        [self.navigationController pushViewController:audioQual animated:YES];
        [audioQual release];
    }
}

#pragma mark - Actions

- (void) preprocessingChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"AudioPreprocessor"];
    if (!sender.on) {
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) micBoostChanged:(UISlider *)sender {
    [[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:@"AudioMicBoost"];
    if (sender.value > 1.0f) {
        [sender setMinimumTrackTintColor:[MUColor badPingColor]];
    } else {
        [sender setMinimumTrackTintColor:[MUColor goodPingColor]];
    }
}

@end
