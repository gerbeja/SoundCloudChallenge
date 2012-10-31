//
//  SCImageView.m
//  SoundCloudChallenge
//
//  Created by German Bejarano on 10/29/12.
//  Copyright (c) 2012 German Bejarano. All rights reserved.
//

#import "SCImageView.h"

@implementation SCImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void) loadAsyncImageWithURL:(NSString *)url{
    /* Creating an Operation Queue for loading the image asynchrously on a separagte Thread */
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(loadImageWithURL:)
                                        object:url];
    [queue addOperation:operation];
}

- (void)loadImageWithURL:(NSString *)url {
    /* Loading the NSData from the URL and creating the UIImage with the NSData */
    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage* image = [UIImage imageWithData:imageData];
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
}

- (void)displayImage:(UIImage *)image {
    /* Setting the image View once finished loading */
    [self setImage:image];
}

@end
