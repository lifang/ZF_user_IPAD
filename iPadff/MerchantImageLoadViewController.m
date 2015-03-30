//
//  MerchantImageLoadViewController.m
//  iPadff
//
//  Created by wufei on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MerchantImageLoadViewController.h"


@interface MerchantImageLoadViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate>


@property(nonatomic,strong) UIPopoverController *popViewController;
@property (nonatomic, assign) BOOL alreadyHasImage;


@end

@implementation MerchantImageLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UI

- (void)initPickerView {
    
}

#pragma mark - Request

- (void)uploadPictureWithImage:(UIImage *)image {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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

#pragma mark - Action

- (void)modifyLocation:(id)sender {
    //重写
   
}

- (void)scanBigImage {
    //重写
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
    [sheet showInView:self.view];
}

 



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    if (_alreadyHasImage) {
        if (buttonIndex == 0) {
            //查看大图
            [self scanBigImage];
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
    /*
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] &&
        buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
*/
    
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]&&
        buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        popover.delegate = self;
        self.popViewController = popover;//对局部UIPopoverController对象popover我们赋给了一个全局的UIPopoverController对象popoverController
       // popover.popoverContentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
       
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
   
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self.popViewController presentPopoverFromRect:CGRectMake(100, 100, 200, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            }];
            
        }
        else
        {
          
          [self.popViewController presentPopoverFromRect:CGRectMake(100, 100, 200, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
         // [self presentViewController:imagePickerController animated:nil completion:nil];
            NSLog(@"GOGO");
        }
    
    }
    
}


#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //[picker dismissViewControllerAnimated:YES completion:nil];
    [self.popViewController dismissPopoverAnimated:NO];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadPictureWithImage:editImage];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{

      //[picker dismissViewControllerAnimated:YES completion:nil];
    [self.popViewController dismissPopoverAnimated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.popViewController dismissPopoverAnimated:NO];
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [[CityHandle shareProvinceList] count];
    }
    else {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:provinceIndex];
        _cityArray = [provinceDict objectForKey:@"cities"];
        return [_cityArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        //省
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:row];
        return [provinceDict objectForKey:@"name"];
    }
    else {
        //市
        return [[_cityArray objectAtIndex:row] objectForKey:@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        //省
        [_pickerView reloadComponent:1];
    }
}

#pragma mark - UIPickerView

- (void)pickerDisplay {
    
    NSLog(@"pickerDiplay");
    
    UIViewController *sortViewController = [[UIViewController alloc] init];
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 276)];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerHide)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(modifyLocation:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [theView addSubview:_toolbar];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, 320, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    [theView addSubview:_pickerView];
    
    sortViewController.view = theView;
    
    _popViewController = [[UIPopoverController alloc] initWithContentViewController:sortViewController];
    [_popViewController setPopoverContentSize:CGSizeMake(320, 216) animated:YES];
    [_popViewController presentPopoverFromRect:CGRectMake(100, 40, 320, 276) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    _popViewController.delegate = self;
    
    
}

- (void)pickerHide
{
    
    [_popViewController dismissPopoverAnimated:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
