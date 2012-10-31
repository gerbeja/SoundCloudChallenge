//
//  SCImageView.h
//  SoundCloudChallenge
//
//  Created by German Bejarano on 10/29/12.
//  Copyright (c) 2012 German Bejarano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCImageView : UIImageView

- (void) loadAsyncImageWithURL:(NSString *)url;

@end
