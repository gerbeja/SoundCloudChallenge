//
//  GlobalConfig.h
//  SoundCloudChallenge
//
//  Created by German Bejarano on 10/30/12.
//  Copyright (c) 2012 German Bejarano. All rights reserved.
//

#pragma mark - General
#define kAppNavBarColor [UIColor colorWithRed:253.0f/255.0f green:89.0f/255.0f blue:9.0f/255.0f alpha:1.0]

#pragma mark - SoundCloud API URLs

#define kFavoritesURL @"https://api.soundcloud.com/users/me/favorites.json"
#define kSoundCloudAppURL @"soundcloud:tracks:%@"

#pragma mark - SoundCloud Favorites WS Fields
#define kFavoritesPermalink @"permalink_url"
#define kFavoritesTitle @"title"
#define kFavoritesWaveFormURL @"waveform_url"
#define kFavoritesCreatedAt @"created_at"
#define kFavoritesId @"id"
