

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "CellBackupSubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrCellBackupSubsystemStatus=@"cellbackup:status";

NSString *const kAttrCellBackupSubsystemErrorState=@"cellbackup:errorState";

NSString *const kAttrCellBackupSubsystemNotReadyState=@"cellbackup:notReadyState";


NSString *const kCmdCellBackupSubsystemBan=@"cellbackup:Ban";

NSString *const kCmdCellBackupSubsystemUnban=@"cellbackup:Unban";


NSString *const kEvtCellBackupSubsystemCellAccessBanned=@"cellbackup:CellAccessBanned";

NSString *const kEvtCellBackupSubsystemCellAccessUnbanned=@"cellbackup:CellAccessUnbanned";

NSString *const kEnumCellBackupSubsystemStatusREADY = @"READY";
NSString *const kEnumCellBackupSubsystemStatusACTIVE = @"ACTIVE";
NSString *const kEnumCellBackupSubsystemStatusNOTREADY = @"NOTREADY";
NSString *const kEnumCellBackupSubsystemStatusERRORED = @"ERRORED";
NSString *const kEnumCellBackupSubsystemErrorStateNONE = @"NONE";
NSString *const kEnumCellBackupSubsystemErrorStateNOSIM = @"NOSIM";
NSString *const kEnumCellBackupSubsystemErrorStateNOTPROVISIONED = @"NOTPROVISIONED";
NSString *const kEnumCellBackupSubsystemErrorStateDISABLED = @"DISABLED";
NSString *const kEnumCellBackupSubsystemErrorStateBANNED = @"BANNED";
NSString *const kEnumCellBackupSubsystemErrorStateOTHER = @"OTHER";
NSString *const kEnumCellBackupSubsystemNotReadyStateNEEDSSUB = @"NEEDSSUB";
NSString *const kEnumCellBackupSubsystemNotReadyStateNEEDSMODEM = @"NEEDSMODEM";
NSString *const kEnumCellBackupSubsystemNotReadyStateBOTH = @"BOTH";


@implementation CellBackupSubsystemCapability
+ (NSString *)namespace { return @"cellbackup"; }
+ (NSString *)name { return @"CellBackupSubsystem"; }

+ (NSString *)getStatusFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CellBackupSubsystemCapabilityLegacy getStatus:modelObj];
  
}


+ (NSString *)getErrorStateFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CellBackupSubsystemCapabilityLegacy getErrorState:modelObj];
  
}


+ (NSString *)getNotReadyStateFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [CellBackupSubsystemCapabilityLegacy getNotReadyState:modelObj];
  
}




+ (PMKPromise *) banOnModel:(SubsystemModel *)modelObj {
  return [CellBackupSubsystemCapabilityLegacy ban:modelObj ];
}


+ (PMKPromise *) unbanOnModel:(SubsystemModel *)modelObj {
  return [CellBackupSubsystemCapabilityLegacy unban:modelObj ];
}

@end
