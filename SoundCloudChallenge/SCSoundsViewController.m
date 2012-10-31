//
//  SCLikesViewController.m
//  SoundCloudChallenge
//
//  Created by German Bejarano on 10/29/12.
//  Copyright (c) 2012 German Bejarano. All rights reserved.
//

#import "SCSoundsViewController.h"
#import "SCImageView.h"
#import "NSString+Extras.h"
#import <JSONKit/JSONKit.h>
#import "MBProgressHUD.h"
#import "SCWebViewController.h"
#import "GlobalConfig.h"

@interface SCSoundsViewController ()

@end

@implementation SCSoundsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        /* Register notifications for knowing when the account status changed on logout and poping up the ViewController */
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(accountDidChange:)
                                                     name:SCSoundCloudAccountDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*  Setting the localized Title */
    self.title = NSLocalizedString(@"Favorites", @"Favorites");
    
    /* Setting Buttons on Navigation Bar */
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadAllSounds)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", @"Logout") style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    
    [self loadAllSounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sounds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* Initializing Cell */
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    /* Getting current Sound Record */
    NSDictionary *currentSound = [self.sounds objectAtIndex:indexPath.row];
    
    /* Setting Cell Values */
    SCImageView *imageView = [[SCImageView alloc] initWithFrame:cell.frame];
    cell.backgroundView = imageView;
    [imageView loadAsyncImageWithURL:[currentSound objectForKey:kFavoritesWaveFormURL]];
    
    cell.textLabel.text = [currentSound objectForKey:kFavoritesTitle];
    
    /* If there is any error on formatting the Date or created_at is nil; showing a message */
    NSString *formattedCreatedAt = [(NSString*)[currentSound objectForKey:kFavoritesCreatedAt] formattedDate];
    cell.detailTextLabel.text = (!formattedCreatedAt)?NSLocalizedString(@"No Created Date Set", @"No Created Date Set"):formattedCreatedAt;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* Getting Seleted Sound */
    NSDictionary *currentSound = [self.sounds objectAtIndex:indexPath.row];
    
    /* Generating URL for opening the sound on SoundCloud App */
    NSURL *soundCloudAppURL = [NSURL URLWithString:[NSString stringWithFormat:kSoundCloudAppURL,[currentSound objectForKey:kFavoritesId]]];
    
    /* Verifying the app can be opened on SoundCloud App (verifying App exists) */
    if ([[UIApplication sharedApplication] canOpenURL:soundCloudAppURL]) {
        [[UIApplication sharedApplication] openURL:soundCloudAppURL];
    } else {
        /* If it doesn't exists open it in an internal WebView (This could also be done on the iOS Safari
         * version by this: [[UIApplication sharedApplication] openURL:soundCloudURL]; after creating
         * soundCloudURL) 
         */
        NSURL *soundCloudURL = [NSURL URLWithString:[currentSound objectForKey:kFavoritesPermalink]];
        SCWebViewController *webViewController = [[SCWebViewController alloc] initWithNibName:@"SCWebViewController" bundle:nil];
        webViewController.url = soundCloudURL;
        webViewController.title = [currentSound objectForKey:kFavoritesTitle];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

#pragma marl - Custom Methods

-(void)loadAllSounds{
    /* Loading Favorites Sounds from API */
    SCAccount *account = [SCSoundCloud account];
    
    /* Showing Loading View */
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    /* Making the GET Call to Favorites */
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:kFavoritesURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                 /* Hides the Loading View */
                 [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                 /* If No error setting the sounds array and reloading data */
                 if (!error) {
                     NSString *responseDataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                     self.sounds = [responseDataString objectFromJSONString];
                     if ((self.sounds==nil)||([self.sounds count]==0)) {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", @"ERROR") message:NSLocalizedString(@"No favorites have been found", @"No favorites have been found") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
                         [alertView show];

                     } else {
                         [self.tableView reloadData];                         
                     }
                 } else {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", @"ERROR") message:NSLocalizedString(@"An error ocurred while fetching the sounds from SoundCloud", @"An error ocurred while fetching the sounds from SoundCloud") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
                     [alertView show];
                 }
             }];
}

-(void)logout{
    /* Logouts the user */
    [SCSoundCloud removeAccess];
}

#pragma mark - Session Notification Handler

- (void)accountDidChange:(NSNotification *)aNotification;
{
    /* If logout successful pop the view controller to the login view */
    SCAccount *account = [SCSoundCloud account];
    if (!account) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
