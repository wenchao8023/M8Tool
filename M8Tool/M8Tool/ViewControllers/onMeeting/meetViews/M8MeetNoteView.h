//
//  M8MeetNoteView.h
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M8MeetNoteView : UIView<ILVLiveIMListener>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
