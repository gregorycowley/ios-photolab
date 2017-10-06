//
//  AsynchFBImageView.m
//  PhotoWorks
//
//  Created by Production One on 9/6/12.
//
//

#import "AsynchFBImageView.h"

@implementation AsynchFBImageView 

//@synthesize delegate;
@synthesize mImageURL;

- (void)dealloc {
	[connection cancel]; //in case the URL is still downloading
	[connection release];
	[data release];
    [super dealloc];
}


- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI {
	//    UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)] autorelease];
	//    [tapRecognizer setNumberOfTapsRequired:1];
	//    [tapRecognizer setDelegate:self];
	//    [self addGestureRecognizer:tapRecognizer];
    self.clipsToBounds = YES;
    
    acitivityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [acitivityView setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    [acitivityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:acitivityView];
    [acitivityView release];
}

- (void)loadImageFromURL:(NSString*)url {
	if (connection!=nil) { [connection release]; } //in case we are downloading a 2nd image
	if (data!=nil) { [data release]; }
	
    self.mImageURL = url;
    loadingImage = NO;
    
    NSURL *imageURL = [NSURL URLWithString:url];
    NSString *imageName = [[imageURL path] urlencode];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    if (image == nil) {
        [acitivityView startAnimating];
		
        __block ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:imageURL];
        httpRequest.imageName = imageName;
        
        [httpRequest setCompletionBlock:^ {
            [acitivityView setHidden:YES];
            [acitivityView stopAnimating];
            if ([[self subviews] count]>0) {
                //then this must be another image, the old one is still in subviews
                [[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
            }
            // Save file in local directory
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, httpRequest.imageName];
            [fileManager createFileAtPath:imagePath contents:httpRequest.responseData attributes:nil];
            
            //make an image view for the image
            [self addImage:[UIImage imageWithData:httpRequest.responseData]];
            [data release]; //don't need this any more, its in the UIImageView now
            data=nil;
			
        }];
        [httpRequest setFailedBlock:^ {
            NSLog(@"Fail");
            [acitivityView setHidden:YES];
            [acitivityView stopAnimating];
        }];
        
        [httpRequest startAsynchronous];
        //TODO error handling, what if connection is nil?
    } else {
        //make an image view for the image
        [self addImage:image];
        loadingImage = YES;
    }
    
}

//just in case you want to get the image directly, here it is in subviews
- (UIImage*) image {
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
}

/*- (void) clickImage {
    if (loadingImage == YES) {
        [delegate showFullImage:self.tag];
    }
}*/

- (void)removeCurrentImage {
    for (UIView *imgView in self.subviews) {
        [imgView removeFromSuperview];
    }
}


- (void)addImage : (UIImage *)img {
    for (UIView *imgView in self.subviews) {
        [imgView removeFromSuperview];
    }
    
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:img] autorelease];
    //make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
    CGRect imageFrame = imageView.frame;
    imageFrame.size.width = 90;
    imageFrame.size.height = 70;
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
    [self addSubview:imageView];
    [imageView setNeedsLayout];
    [self setNeedsLayout];
}
/*
- (void)initImage : (UIImage *)img {
    [self addImage:img];
}*/


@end
