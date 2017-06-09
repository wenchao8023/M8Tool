//
//  M8CallVideoNoteView.h
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M8CallVideoNoteView : UIView<TILCallNotificationListener>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
