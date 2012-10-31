//
//  SCViewController.m
//  SoundCloudChallenge
//
//  Created by German Bejarano on 10/28/12.
//  Copyright (c) 2012 German Bejarano. All rights reserved.
//

#import "SCViewController.h"
#import "SCSoundsViewController.h"
#import <JSONKit/JSONKit.h>

@interface SCViewController ()

@end

@implementation SCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        /* Register notifications for knowing when the account status changed */
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
    self.title = NSLocalizedString(@"Login", @"Login");
    
    /* Verifying of the the account is still valid:
            - If valid go to the Favorites View Controller
            - If not open Login*/
    SCAccount *account = [SCSoundCloud account];
    if (account) {
        SCSoundsViewController *soundsViewController = [self soundsViewController];
        [self.navigationController pushViewController:soundsViewController animated:YES];
    } else {
        [self login:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom
- (SCSoundsViewController *)soundsViewController
{
    /* Wrapper for getting the View controller used for showing shounds*/
    SCSoundsViewController *soundsViewController = [[SCSoundsViewController alloc] initWithNibName:@"SCSoundsViewController" bundle:nil];
    return soundsViewController;
}

- (IBAction)login:(id)sender
{
    /* Open Login View from SoundCloud SDK */
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
        
        SCLoginViewController *loginViewController;
        loginViewController = [SCLoginViewController loginViewControllerWithPreparedURL:preparedURL
                                                                      completionHandler:^(NSError *error){
                                                                          
                                                                          if (SC_CANCELED(error)) {
                                                                              NSLog(@"Canceled!");
                                                                          } else if (error) {
                                                                              NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                                                                          } else {
                                                                              NSLog(@"Done!");
                                                                          }
                                                                      }];
        
        [self presentViewController:loginViewController animated:NO completion:^{
            NSLog(@"Opened");
        }];
    }];
}

#pragma mark - Handle Account Changes

- (void)accountDidChange:(NSNotification *)aNotification;
{
    /* When the account changed the status if valid go to SoundsViewController */
    SCAccount *account = [SCSoundCloud account];
    if (account) {
        SCSoundsViewController *soundsViewController = [self soundsViewController];
        [self.navigationController pushViewController:soundsViewController animated:YES];
    } else {
        /* We should show a message but since the same notification is being used for logout, for now leaving this empty*/
    }
}


@end
