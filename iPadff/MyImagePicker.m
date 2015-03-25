//
//  MyImagePicker.m

//
//  Created by wufei on 15/3/24.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MyImagePicker.h"

@interface MyImagePicker ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate>


@property(nonatomic,strong) UIPopoverController *popViewController;
@property (nonatomic, assign) BOOL alreadyHasImage;


@end


@implementation MyImagePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        
      
    }
    return self;
}




#pragma mark - Request

- (void)uploadPictureWithImage:(UIImage *)image {
       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
       hud.labelText = @"上传中...";
       [NetworkInterface uploadMerchantImageWithImage:image finished:^(BOOL success, NSData *response) {
          NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
          hud.customView = [[UIImageView alloc] init];
           hud.mode = MBProgressHUDModeCustomView;
           [hud hide:YES afterDelay:0.5f];
           if (success) {
               id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
               if ([object isKindOfClass:[NSDictionary class]]) {
              NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
             if ([errorCode intValue] == RequestFail) {
                //返回错误代码
                hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                   }
                else if ([errorCode intValue] == RequestSuccess) {
                hud.labelText = @"图片上传成功";
                [self parseImageUploadInfo:object];
                }
              }
              else {
               //返回错误数据
                 hud.labelText = kServiceReturnWrong;
                }
                 }
             else {
                 hud.labelText = kNetworkFailed;
                 }
             }];
        }

#pragma mark - Data

- (void)saveWithURLString:(NSString *)urlString {
    //重写
}

- (void)parseImageUploadInfo:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    NSString *urlString = [infoDict objectForKey:@"filePath"];
    [self saveWithURLString:urlString];
}




#pragma mark

- (void)selectedKey:(NSString *)imageKey
           hasImage:(BOOL)hasImage {
    _alreadyHasImage = hasImage;
    _selectedImageKey = imageKey;
    UIActionSheet *sheet = nil;
    if (hasImage) {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"查看原图",@"相册上传",@"拍照上传",nil];
        
        
    }
    else
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"相册上传",@"拍照上传",nil];
    }
    [sheet showInView:self];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    if (_alreadyHasImage) {
        if (buttonIndex == 0) {
            //查看大图
            return;
        }
        else if (buttonIndex == 1) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 2) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    else {
        if (buttonIndex == 0) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 1) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]&&
        buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        popover.delegate = self;
        // popover.popoverContentSize = CGSizeMake(500, 700);
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                popover.popoverContentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
                [popover presentPopoverFromRect:CGRectMake(100, 100, 200, 300) inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            }];
            
        }
        else
        {
            [popover presentPopoverFromRect:CGRectMake(100, 100, 200, 300) inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    
}


#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadPictureWithImage:editImage];
}




@end
