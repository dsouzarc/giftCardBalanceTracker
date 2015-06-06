//
//  AddNewCardViewController.h
//  Gift Card Balance Tracker
//
//  Created by Ryan D'souza on 6/6/15.
//  Copyright (c) 2015 Ryan D'souza. All rights reserved.
//

#import "ViewController.h"
#import "OneVanillaGiftCard.h"

@class AddNewCardViewController;

@protocol AddNewCardViewControllerDelegate <NSObject>

- (void) addNewCardViewController:(AddNewCardViewController*)controller newCard:(id<Card>)newCard;

@end

@interface AddNewCardViewController : ViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<AddNewCardViewControllerDelegate> delegate;

@end
