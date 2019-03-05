//
//  PeopleModelManager.m
//  i2app
//
//  Created by Arcus Team on 9/24/15.
/*
 * Copyright 2019 Arcus Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//

#import <i2app-Swift.h>
#import "PeopleModelManager.h"
#import "PersonController.h"


@interface PeopleModelManager()

@property (nonatomic) NSInteger index;

@end

@implementation PeopleModelManager

+ (PeopleModelManager *)create:(NSArray *)people {
    PeopleModelManager *manager = [[PeopleModelManager alloc] init];
    
    NSArray *keys = @[[[NSSortDescriptor alloc] initWithKey:@"fullName" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    NSArray *sortedArray = [people sortedArrayUsingDescriptors:keys];
    
    manager.people = sortedArray;
    return manager;
}

- (PersonModel *)getCurrent {
    NSArray *peopleList = self.people;

    if (self.index > peopleList.count - 1) {
        return peopleList[0];
    }
    else if (self.index < peopleList.count) {
        return [peopleList objectAtIndex:self.index];
    }
    return nil;
}

- (PersonModel *)getNext {
    if (self.people.count == 0) {
        return nil;
    }
    NSArray *peopleList = self.people;

    NSInteger index = self.index;
    if (index < peopleList.count - 1) {
        index++;
    }
    else {
        index = 0;
    }
    return peopleList[index];
}

- (PersonModel *)getPrevious {
    NSArray *peopleList = self.people;

    NSInteger index = self.index;
    if (index > 0) {
        index--;
    }
    else {
        index = peopleList.count - 1;
    }
    return peopleList[index];
}

- (PersonModel *)setCurrentToIndex:(NSInteger)index {
    NSArray *peopleList = self.people;
    
    if (index < peopleList.count - 1 || index >= 0) {
        self.index = index;
    }
    else {
        return nil;
    }
    
    return peopleList[index];
}

- (BOOL)setCurrentTo:(PersonModel *)people {
    if ([[self getCurrent] isEqual:people]) {
        return YES;
    }
    
    NSArray *peopleList = self.people;
    
    for (NSInteger i = 0; i < peopleList.count; i++) {
        if ([peopleList[i] isEqual:people]) {
            self.index = i;
            return YES;
        }
    }

    if ([people isKindOfClass:[PersonModel class]]) {
        NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:peopleList];
        [newArray addObject:people];
        
        NSArray *keys = @[[[NSSortDescriptor alloc] initWithKey:@"fullName" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
        NSArray *sortedArray = [newArray sortedArrayUsingDescriptors:keys];
        
        self.people = sortedArray;
        return [self setCurrentTo:people];
    }
    return NO;
}

@end

