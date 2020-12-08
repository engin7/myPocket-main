//
//  ViewController.h
//  My Pocket
//
//  Created by Engin KUK on 30.11.2020.
//

#import <UIKit/UIKit.h>
#import "myPocket-Swift.h" // to access Swift files with @objc prefix

@interface ViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *type;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *values;
@property (nonatomic, assign) NSInteger balance;

@property (nonatomic, assign) NSString *EntryID;
@property (nonatomic, assign) NSString *EntryTitle;
@property (nonatomic, assign) NSString *EntryType;
@property (nonatomic, assign) NSString *EntryAmount;

@property (strong, nonatomic) NSMutableArray<Entry *> *entries;

@end

