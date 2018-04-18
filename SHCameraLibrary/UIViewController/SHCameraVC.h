//
//  FirstViewController.h
//  SHCamera
//
//  Created by xianjunwang on 2018/4/17.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnBlock)(UIImage * image);

@interface SHCameraVC : UIViewController

@property (nonatomic,copy) ReturnBlock returnBlock;

@end
