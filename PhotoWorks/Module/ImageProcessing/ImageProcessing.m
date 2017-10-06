//
//  ImageProcessing.m
//  PhotoWorks
//
//  Created by Production One on 8/31/12.
//
//

#import "ImageProcessing.h"

@implementation ImageProcessing


#pragma mark - Static Methods

+ (CGRect)cropSizeToRatio:(CGSize)originalSize ratio:(NSArray *)ratioArray{
	int ratioWidth = [[ratioArray objectAtIndex:0] integerValue];
	int ratioHeight = [[ratioArray objectAtIndex:1] integerValue];
	float originalRatio = originalSize.width / originalSize.height;
	float cropRatio = (float)ratioWidth/(float)ratioHeight;

	NSLog(@"Original Image Width: %f Height: %f", originalSize.width, originalSize.height);
	
	int offsetX = 0;
	int offsetY = 0;
	float newWidth = 0;
	float newHeight = 0;
	if ( cropRatio >= originalRatio){
		// Use width - Horizontal Ratio:  A = Width, B = A/ratio
		newWidth = originalSize.width;
		newHeight = newWidth/cropRatio;
		offsetX = 0;
		offsetY = -(originalSize.height - newHeight) / 2;

	} else if ( cropRatio < originalRatio ) {
		// Use Height - Vertical Ratio: A = Height, B = A * ratio
		newHeight = originalSize.height;
		newWidth = newHeight * cropRatio;
		offsetX = -(originalSize.width - newWidth) / 2;
		offsetY = 0;
		
	}
	
	NSLog(@"New Image Width: %f Height: %f width an X: %d and Y: %d", newWidth, newHeight, offsetX, offsetY);
	return CGRectMake( offsetX, offsetY, newWidth, newHeight);
}


+ (CGRect) aspectFittedRect:(CGRect)inRect max:(CGRect)maxRect
{
	float originalAspectRatio = inRect.size.width / inRect.size.height;
	float maxAspectRatio = maxRect.size.width / maxRect.size.height;

	CGRect newRect = maxRect;
	if (originalAspectRatio > maxAspectRatio) { // scale by width
		newRect.size.height = maxRect.size.width * inRect.size.height / inRect.size.width;
		newRect.origin.y += (maxRect.size.height - newRect.size.height)/2.0;
	
	} else {
		newRect.size.width = maxRect.size.height  * inRect.size.width / inRect.size.height;
		newRect.origin.x += (maxRect.size.width - newRect.size.width)/2.0;
		
	}
   
   return CGRectIntegral(newRect);
}

+ (CGRect) aspectFilledRect:(CGRect)inRect max:(CGRect)maxRect
{
	float originalAspectRatio = inRect.size.width / inRect.size.height;
	float maxAspectRatio = maxRect.size.width / maxRect.size.height;
	
	CGRect newRect = maxRect;
	if (originalAspectRatio < maxAspectRatio) { // scale by width
		newRect.size.height = maxRect.size.width * inRect.size.height / inRect.size.width;
		newRect.origin.y += (maxRect.size.height - newRect.size.height)/2.0;
		
	} else {
		newRect.size.width = maxRect.size.height  * inRect.size.width / inRect.size.height;
		newRect.origin.x += (maxRect.size.width - newRect.size.width)/2.0;
		
	}
	
	return CGRectIntegral(newRect);
}

+ (UIImage *) cropImageToRect:(UIImage *)image rect:(CGRect)rect{
	if (rect.size.width == 0 && rect.size.height == 0) return image;
	
	CGSize imageSize = image.size;
	CGRect imageRectWithoutCrop = CGRectMake(rect.origin.x, rect.origin.y, imageSize.width, imageSize.height);
	UIGraphicsBeginImageContext(rect.size);
	[image drawInRect:imageRectWithoutCrop];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}


+ (NSArray *) flipRatioArray:(NSString *)ratio originalImageSize:(CGSize)originalImageSize{
    
    NSArray *ratioArray = [ratio componentsSeparatedByString:@":" ];

    NSLog(@"-------------------------------------------- <<<< ");
    NSLog(@"Original Image Size -> Width:%f Height:%f", originalImageSize.width, originalImageSize.height);
    // Match orientation of ratio to the orientation of the image:

    float imageRatio = originalImageSize.width / originalImageSize.height;
    float cropRatio = [[ratioArray objectAtIndex:0] floatValue]/[[ratioArray objectAtIndex:1] floatValue];
    if (imageRatio > 1){
        NSLog(@"Original Image is Horizontal");
        // image is horizontal
        if ( cropRatio >= 1){
            // Crop is also horizontal(or square), all is good;
        } else {
            // crop is vertical, rotate it
            NSString *newRatio = [NSString stringWithFormat:@"%f:%f", [[ratioArray objectAtIndex:1] floatValue], [[ratioArray objectAtIndex:0] floatValue] ];
            ratioArray = [newRatio componentsSeparatedByString:@":" ];
        }
    } else {
        NSLog(@"Original Image is Vertical");
        // Image is vertical or square:
        if ( cropRatio > 1){
            // crop is horizontal, rotate it
            NSString *newRatio = [NSString stringWithFormat:@"%f:%f", [[ratioArray objectAtIndex:1] floatValue], [[ratioArray objectAtIndex:0] floatValue] ];
            ratioArray = [newRatio componentsSeparatedByString:@":" ];
            
        } else {
            // Crop is also vertical(or square), all is good;
            
        }
    }
    return ratioArray;
}

+ (UIImage *) cropImageToSize:(UIImage *)image cropSize:(CGSize)cropSize {
	// Scale image to fill frame:
	CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
	
	//Create a frame rect with 0 origin. Cannot use frame directly because it has origin values set.
	CGRect currentFrame = CGRectMake(0, 0, cropSize.width, cropSize.height);
	CGRect newScaleRect = [ImageProcessing aspectFilledRect:imageRect max:currentFrame];
	
	// Generate our new image, cropped to the format of this view.
	UIGraphicsBeginImageContext(cropSize);
	[image drawInRect:newScaleRect];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}





#pragma mark - Public Methods

- (void)centerImage:(UIImage *)image imgView:(UIImageView *)imgView parentView:(UIView *)parentView{
	float imageViewY = imgView.frame.origin.y;
    float imageViewHeight = imgView.bounds.size.width;
    int offsetX = ((parentView.frame.size.width - image.size.width) / 2);
    int offsetY = (imageViewY + ((imageViewHeight - image.size.height) / 2));
    imgView.frame = CGRectMake(offsetX, offsetY, image.size.width, image.size.height);
}

- (void)addDropShadow:(UIImageView *)imgView{
	/*
	 [[imgView layer] setShadowOffset:CGSizeMake(0, 1)];
	[[imgView layer] setShadowColor:[[UIColor darkGrayColor] CGColor]];
	[[imgView layer] setShadowRadius:3.0];
	[[imgView layer] setShadowOpacity:0.8];
	 */
}

- (NSString *) getImageOrientation:(UIImage *)image{
	CGSize size = image.size;
	if ( size.width >= size.height){
		return @"horizontal";
	} else {
		return @"vertical";
	}
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
	
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
	
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
	
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
	
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
	
    return newImage;
}



/*
 - (CGRect)getCropFromDataObject:(int)imageIndex{
 // Set image crop:
 CGRect imageCrop = [[OrderManager sharedInstance] getImageCropValues:imageIndex];
 float imageViewWidth = mProductImgView.bounds.size.width;
 float cropWidth = imageCrop.size.width;
 float cropHeight = imageCrop.size.height;
 float scaleDifference = imageViewWidth / cropWidth;
 int newWidth = cropWidth * scaleDifference;
 int newHeight = cropHeight * scaleDifference;
 int newX = (imageCrop.origin.x * scaleDifference);
 int newY = (imageCrop.origin.y * scaleDifference);
 return CGRectMake(newX, newY, newWidth, newHeight);
 }
 
 - (CGSize) refactorImageSizeForCrop:(UIImage * )image crop:(CGRect)crop{
 CGSize oriSize = image.size;
 NSString *orientation = [self getImageOrientation:image];
 float scale = 1;
 if (orientation == @"horizontal"){
 scale = crop.size.height / oriSize.height;
 }else if(orientation == @"vertical"){
 scale = crop.size.width / oriSize.width;
 }
 return CGSizeMake((oriSize.width * scale), (oriSize.height * scale));
 }
 
 - (UIImage *)cropImage:(UIImage * )image crop:(CGRect)crop{
 // This will crop an image that is too large:
 CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], crop);
 UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
 CGImageRelease(imageRef);
 return croppedImage;
 }
 */


- (void) updatePhotoPreview:(UIImage *)selectedImage imageWindow:(UIScrollView *)imageWindow imageView:(UIImageView *)imageView{
    // Collect parameters for image:
    NSString *imageFormat = [ImageProcessing findFormat:selectedImage];
	int imageWidth = selectedImage.size.width;
	int imageHeight = selectedImage.size.height;
	
	// Get the size of the image window:
    NSString *imageRatio = [self findRatio];
	//mScrollView.frame = [self resizeWindowToRatio:(NSString *)imageFormat imageWindow:(UIScrollView *)imageWindow];
    imageWindow.frame = [self resizeWindowRectToRatio:imageWindow ratio:imageRatio imageFormat:imageFormat];
	
	// Calculate the scale change needed:
    float scale = [self findScale:selectedImage imageWindow:imageWindow];
	
    // Size the image
    CGSize newSize = CGSizeMake(imageWidth * scale, imageHeight * scale);
	UIImage *scaledImage = [self imageWithImage:selectedImage scaledToSize:newSize];
    
    // Set the image
	[imageView setImage: scaledImage];
    
    // Update the Scroll Container
    imageWindow.contentSize = [[imageView image] size];
    imageWindow.decelerationRate = 0.0f;
    imageWindow.bounces = NO;
    
    /// Save the cropped values:
    float imageWindowWidth = imageWindow.frame.size.width;
	float imageWindowHeight = imageWindow.frame.size.height;
    [self saveCropData:CGRectMake(0, 0, imageWindowWidth, imageWindowHeight)];
    [[OrderManager sharedInstance] setImageSize:selectedImage.size];
}

- (NSString *) findRatio{
    ProductOptionData *sProductOptionData = [[OrderManager sharedInstance] getProductOptionData];
    return (sProductOptionData.mProductOptionRatio == (id)[NSNull null] || sProductOptionData.mProductOptionRatio.length == 0) ?  @"1:1" : sProductOptionData.mProductOptionRatio;
}

+ (NSString *) findFormat:(UIImage *)image{
    float imageWidth = image.size.width;
	float imageHeight = image.size.height;
	float result = imageWidth/imageHeight;
	NSString *imageFormat = nil;
	if ( result > 1 ){
		imageFormat = @"horizontal";
	}else if ( result < 1 ){
		imageFormat = @"vertical";
	}else if ( result == 1 ){
		imageFormat = @"square";
	}
    return imageFormat;
}

+ (NSString *) findFormatFromSize:(CGSize)imageSize{
    float imageWidth = imageSize.width;
	float imageHeight = imageSize.height;
	float result = imageWidth/imageHeight;
	NSString *imageFormat = nil;
	if ( result > 1 ){
		imageFormat = @"horizontal";
	}else if ( result < 1 ){
		imageFormat = @"vertical";
	}else if ( result == 1 ){
		imageFormat = @"square";
	}
    return imageFormat;
    
}




- (float) findScale:(UIImage *)image imageWindow:(UIScrollView *)imageWindow {
    // Calculate the scale change needed:
    // Find the narrowing point ::
	float scale = 0.0;
    NSString *imageFormat = [ImageProcessing findFormat:image];
    float imageWindowWidth = imageWindow.frame.size.width;
	float imageWindowHeight = imageWindow.frame.size.height;
    int imageWidth = image.size.width;
	int imageHeight = image.size.height;
	if ( imageFormat == @"horizontal" ){
		// Compare heights:
		if ( imageHeight >  imageWindowHeight ) {
			scale = imageWindowHeight / imageHeight;
		}else {
			scale = imageWindowHeight / imageHeight;//imageHeight / imageWindowHeight;
		}
        
	} else if ( imageFormat == @"vertical" || imageFormat == @"square") {
		// Compare widths:
		if ( imageWidth >  imageWindowWidth ) {
			scale = imageWindowWidth / imageWidth;
		}else {
			//scale = imageWidth / imageWindowWidth;
            scale = imageWindowWidth / imageWidth;
		}
	}
    return scale;
    
}

- (float) calculateScale:(CGRect)originalRect newRect:(CGRect)newRect {
    // Calculate the scale change needed:
	float scale = 0.0;
	// Ratios should be equal:
	float originalRatio = originalRect.size.width/originalRect.size.height;
	float newRatio = newRect.size.width/newRect.size.height;
	if (originalRatio > newRatio) {
		scale = newRect.size.width / originalRect.size.width;
		
	} else {
		scale = newRect.size.height / originalRect.size.height;
		
	}
    return scale;
}


- (UIImage *) scaleImage:(float)scale image:(UIImage *)image {
    int imageWidth = image.size.width;
	int imageHeight = image.size.height;
    CGSize newSize = CGSizeMake(imageWidth * scale, imageHeight * scale);
	UIImage *scaledImage = [self imageWithImage:image scaledToSize:newSize];
    return scaledImage;
}

- (CGRect) resizeWindowRectToRatio:(UIScrollView *)window ratio:(NSString *)ratio imageFormat:(NSString *)imageFormat{
    
    float imageWindowX = window.frame.origin.x;
	float imageWindowY = window.frame.origin.y;
	float imageWindowWidth = window.frame.size.width;
	float imageWindowHeight = window.frame.size.height;
	
	NSArray* ratioArray = [ratio componentsSeparatedByString: @":"];
	if ([ratioArray count] > 0){
		// Resize the scrollview to fit the ratio in db:
		if ( imageFormat == @"horizontal" ){
			int rationLeft = [[ratioArray objectAtIndex:0] integerValue];
			int rationRight = [[ratioArray objectAtIndex:1] integerValue];
			if ( rationLeft > rationRight) {
				// Like 4:3, left is the width;
				imageWindowWidth = 245.0;
				imageWindowHeight = ((rationRight * imageWindowWidth ) / rationLeft);
				
			} else {
				// Like 3:4 or square
				imageWindowWidth = 245.0;
				imageWindowHeight = (( rationLeft * imageWindowWidth ) / rationRight);
			}
			
		}else if ( imageFormat == @"vertical" || imageFormat == @"square"){
			int rationLeft = [[ratioArray objectAtIndex:0] integerValue];
			int rationRight = [[ratioArray objectAtIndex:1] integerValue];
			if ( rationLeft > rationRight) {
				// Like 4:3, left is the width;
				imageWindowWidth = ((rationRight * imageWindowWidth ) / rationLeft);
				imageWindowHeight = 245.0;
				
			} else {
				// Like 3:4 or square
				imageWindowWidth = 245.0;
				imageWindowHeight = ((rationLeft * imageWindowWidth ) / rationRight);
			}
		}
	}
	
	int newPosX = imageWindowX + (( 245 - imageWindowWidth)/2);
	int newPosY = imageWindowY + (( 245 - imageWindowHeight)/2);
	
	return CGRectMake(newPosX, newPosY, imageWindowWidth, imageWindowHeight);
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) saveCropData:(CGRect)crop {
	//int cropX = crop.origin.x;
	//int cropY = crop.origin.y;
	//int cropWidth = crop.size.width;
	//int cropHeight = crop.size.height;
	//mImageCrop = CGRectMake(cropX, cropY, cropWidth, cropHeight);
}

@end
