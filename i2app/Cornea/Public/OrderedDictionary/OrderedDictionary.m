//
//  OrderedDictionary.m
//  OrderedDictionary
//
//  xCopyright 2008 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

#import <i2app-Swift.h>
#import "OrderedDictionary.h"

NSString *DescriptionForObject(NSObject *object, id locale, NSUInteger indent) {
	NSString *objectString;
	if ([object isKindOfClass:[NSString class]]) {
		objectString = (NSString *)object;
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
		objectString = [(NSDictionary *)object descriptionWithLocale:locale indent:indent];
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:)]) {
		objectString = [(NSSet *)object descriptionWithLocale:locale];
	}
	else {
		objectString = [object description];
	}
	return objectString;
}

@implementation OrderedDictionary {
    NSMutableDictionary     *_dictionary;
    NSMutableArray          *_array;
}

- (instancetype)init {
    if (self = [super init]) {
        _dictionary = [[NSMutableDictionary alloc] init];
        _array = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
	if (self = [super init]) {
		_dictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
		_array = [[NSMutableArray alloc] initWithCapacity:capacity];
	}
	return self;
}

- (void)sortArray {
    _array = [[NSMutableArray alloc] initWithArray:[_array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
}

- (void)sortArrayBasedOnNumberInKey {
    NSArray *sortedArray = [_array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([[obj1 substringFromIndex:1] intValue] > [[obj2 substringFromIndex:1] intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([[obj1 substringFromIndex:1] intValue] < [[obj2 substringFromIndex:1] intValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    _array = sortedArray.mutableCopy;
}

- (instancetype)copy {
	return [self mutableCopy];
}

- (void)setObject:(id)anObject forKey:(id)aKey {
    if(_dictionary != nil) {
        if(anObject != nil) {
            if (![_dictionary objectForKey:aKey])
            {
                [_array addObject:aKey];
            }
            [_dictionary setObject:anObject forKey:aKey];
        } else {
            DDLogInfo(@"setObject:forKey anObject is nil");
        }
    } else {
        DDLogInfo(@"setObject:forKey _dictionary is nil");
    }
}

- (void)removeObjectForKey:(id)aKey {
	[_dictionary removeObjectForKey:aKey];
	[_array removeObject:aKey];
}

- (NSUInteger)count {
	return [_dictionary count];
}

- (id)objectForKey:(id)aKey {
	return [_dictionary objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator {
	return [_array objectEnumerator];
}

- (NSEnumerator *)reverseKeyEnumerator {
	return [_array reverseObjectEnumerator];
}

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex {
	if ([_dictionary objectForKey:aKey]) {
		[self removeObjectForKey:aKey];
	}
	[_array insertObject:aKey atIndex:anIndex];
	[_dictionary setObject:anObject forKey:aKey];
}

- (id)keyAtIndex:(NSUInteger)anIndex {
	return _array[anIndex];
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
	NSMutableString *indentString = [NSMutableString string];
	NSUInteger i, count = level;
	for (i = 0; i < count; i++) {
		[indentString appendFormat:@"    "];
	}
	
	NSMutableString *description = [NSMutableString string];
	[description appendFormat:@"%@{\n", indentString];
	for (NSObject *key in self) {
		[description appendFormat:@"%@    %@ = %@;\n",
			indentString,
			DescriptionForObject(key, locale, level),
			DescriptionForObject([self objectForKey:key], locale, level)];
	}
	[description appendFormat:@"%@}\n", indentString];
	return description;
}

- (void)reverseObjects {
    _array = _array.reverseObjectEnumerator.allObjects.mutableCopy;
}

@end
