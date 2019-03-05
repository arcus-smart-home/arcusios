

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;



/**  READY:  Will work: Modem is plugged in, healthy, connected, and add on subscription exists for place ACTIVE:  Is working: Hub is actively connected to hub bridge via cellular NOTREADY:  Will not work (user recoverable) : check notReadyState to see if they need a modem or a subscription ERRORED:  Will not work (requires contact center) : check erroredState for more information  */
extern NSString *const kAttrCellBackupSubsystemStatus;

/**  NONE:  No error NOSIM:  Modem is plugged in but does not have a SIM NOTPROVISIONED:  Modem is plugged in but SIM is/was not properly provisioned DISABLED: BANNED: OTHER:  Modem is pluggin in and has a provisioned SIM but for some reason it cannot connect (hub4g:connectionStatus will have a vendor specific code as to why)  */
extern NSString *const kAttrCellBackupSubsystemErrorState;

/**  NEEDSSUB:  Modem is plugged in, healthy, and connected, but no add on subscription for place exists NEEDSMODEM:  Add on subscription for place exists, but no modem plugged in BOTH:  Needs both modem and subscription  */
extern NSString *const kAttrCellBackupSubsystemNotReadyState;


extern NSString *const kCmdCellBackupSubsystemBan;

extern NSString *const kCmdCellBackupSubsystemUnban;


extern NSString *const kEvtCellBackupSubsystemCellAccessBanned;

extern NSString *const kEvtCellBackupSubsystemCellAccessUnbanned;

extern NSString *const kEnumCellBackupSubsystemStatusREADY;
extern NSString *const kEnumCellBackupSubsystemStatusACTIVE;
extern NSString *const kEnumCellBackupSubsystemStatusNOTREADY;
extern NSString *const kEnumCellBackupSubsystemStatusERRORED;
extern NSString *const kEnumCellBackupSubsystemErrorStateNONE;
extern NSString *const kEnumCellBackupSubsystemErrorStateNOSIM;
extern NSString *const kEnumCellBackupSubsystemErrorStateNOTPROVISIONED;
extern NSString *const kEnumCellBackupSubsystemErrorStateDISABLED;
extern NSString *const kEnumCellBackupSubsystemErrorStateBANNED;
extern NSString *const kEnumCellBackupSubsystemErrorStateOTHER;
extern NSString *const kEnumCellBackupSubsystemNotReadyStateNEEDSSUB;
extern NSString *const kEnumCellBackupSubsystemNotReadyStateNEEDSMODEM;
extern NSString *const kEnumCellBackupSubsystemNotReadyStateBOTH;


@interface CellBackupSubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getStatusFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getErrorStateFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getNotReadyStateFromModel:(SubsystemModel *)modelObj;





/** Sets status = ERRORED, errorState = BANNED so that the hub bridge will not auth this hub if it connects via cellular. */
+ (PMKPromise *) banOnModel:(Model *)modelObj;



/** Resets status to best-choice [READY, ACTIVE, NOTREADY] and sets errorState to NONE */
+ (PMKPromise *) unbanOnModel:(Model *)modelObj;



@end
