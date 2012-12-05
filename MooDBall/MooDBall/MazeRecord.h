//
// Created by vladsaveliev on 22 Nov.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface MazeRecord : NSObject {
    sqlite3 *database;

    NSString *data;
    size_t width;
    size_t height;
}
@end