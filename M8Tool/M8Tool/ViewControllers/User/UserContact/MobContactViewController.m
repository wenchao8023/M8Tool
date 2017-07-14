//
//  MobContactViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MobContactViewController.h"

#import <AddressBook/AddressBook.h>

@interface MobContactViewController ()

@end

@implementation MobContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)getMobContact
//{
//    ABAddressBookRef addressBooks = nil;
//    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
//        
//    {
//        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
//        
//        //获取通讯录权限
//        
//        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//        
//        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
//        
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//    }
//    
//    else
//        
//    {
//        addressBooks = ABAddressBookCreate();
//        
//    }
//    
//    //获取通讯录中的所有人
//    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
//    //通讯录中人数
//    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
//    
//    //循环，获取每个人的个人信息
//    for (NSInteger i = 0; i < nPeople; i++)
//    {
//        //新建一个addressBook model类
//        TKAddressBook *addressBook = [[TKAddressBook alloc] init];
//        //获取个人
//        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
//        //获取个人名字
//        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
//        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
//        CFStringRef abFullName = ABRecordCopyCompositeName(person);
//        NSString *nameString = (__bridge NSString *)abName;
//        NSString *lastNameString = (__bridge NSString *)abLastName;
//        
//        if ((__bridge id)abFullName != nil) {
//            nameString = (__bridge NSString *)abFullName;
//        } else {
//            if ((__bridge id)abLastName != nil)
//            {
//                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
//            }
//        }
//        addressBook.name = nameString;
//        addressBook.recordID = (int)ABRecordGetRecordID(person);;
//        
//        ABPropertyID multiProperties[] = {
//            kABPersonPhoneProperty,
//            kABPersonEmailProperty
//        };
//        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
//        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
//            ABPropertyID property = multiProperties[j];
//            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
//            NSInteger valuesCount = 0;
//            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
//            
//            if (valuesCount == 0) {
//                CFRelease(valuesRef);
//                continue;
//            }
//            //获取电话号码和email
//            for (NSInteger k = 0; k < valuesCount; k++) {
//                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
//                switch (j) {
//                    case 0: {// Phone number
//                        addressBook.tel = (__bridge NSString*)value;
//                        break;
//                    }
//                    case 1: {// Email
//                        addressBook.email = (__bridge NSString*)value;
//                        break;
//                    }
//                }
//                CFRelease(value);
//            }
//            CFRelease(valuesRef);
//        }
//        
//        NSMutableDictionary *jsonDict=[NSMutableDictionary dictionary];
//        
//        if (nameString .length == 0 || nameString == nil) {
//            nameString=@"我的通讯录好友";
//        }
//        [jsonDict setObject:nameString forKey:@"nickname"];
//        
//        if (addressBook.tel.length > 0) {
//            [jsonDict setObject:[NSString stringWithFormat:@"%@",addressBook.tel] forKey:@"mobile"];
//        }
//        
//        
//        
//        
//        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
//        [_addressBookTemp addObject:jsonDict];
//        
//        if (abName) CFRelease(abName);
//        if (abLastName) CFRelease(abLastName);
//        if (abFullName) CFRelease(abFullName);
//    }
//    
//    
//    
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    if (GETTOKEN) {
//        [dict setObject:GETTOKEN forKey:@"authToken"];
//    }
//    
//    
//    
//    NSData *dataFriends = [NSJSONSerialization dataWithJSONObject:self.addressBookTemp options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSString *jsonString = [[NSString alloc] initWithData:dataFriends
//                            
//                                                 encoding:NSUTF8StringEncoding];
//    
//    
//    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    
//    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//    
//    NSString *newStr=[ImportContactListViewController delSpaceAndNewline:jsonString];
//    
//    
//    NSMutableString *muStr=[NSMutableString stringWithFormat:@"%@",newStr];
//    
//    
//    
//    NSString *character = nil;
//    for (int i=0; i<muStr.length; i++) {
//        
//        character = [muStr substringWithRange:NSMakeRange(i, 1)];
//        if ([character isEqualToString:@"\n"]){
//            
//            [muStr deleteCharactersInRange:NSMakeRange(i, 1)];
//        }
//    }
//    
//    NSString *character1 = nil;
//    for (int i=0; i<muStr.length; i++) {
//        
//        character1 = [muStr substringWithRange:NSMakeRange(i, 1)];
//        if ([character isEqualToString:@"\r"]){
//            
//            [muStr deleteCharactersInRange:NSMakeRange(i, 1)];
//        }
//    }
//}
@end
