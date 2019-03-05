

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "IcstDocumentCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrIcstDocumentCreated=@"icstdoc:created";

NSString *const kAttrIcstDocumentId=@"icstdoc:id";

NSString *const kAttrIcstDocumentDocType=@"icstdoc:docType";

NSString *const kAttrIcstDocumentDocument=@"icstdoc:document";

NSString *const kAttrIcstDocumentModified=@"icstdoc:modified";

NSString *const kAttrIcstDocumentModifiedBy=@"icstdoc:modifiedBy";

NSString *const kAttrIcstDocumentVersion=@"icstdoc:version";

NSString *const kAttrIcstDocumentApproved=@"icstdoc:approved";

NSString *const kAttrIcstDocumentApprovedBy=@"icstdoc:approvedBy";


NSString *const kCmdIcstDocumentCreateDocument=@"icstdoc:CreateDocument";

NSString *const kCmdIcstDocumentApproveDocument=@"icstdoc:ApproveDocument";

NSString *const kCmdIcstDocumentRejectDocument=@"icstdoc:RejectDocument";

NSString *const kCmdIcstDocumentListDocumentMetadata=@"icstdoc:ListDocumentMetadata";

NSString *const kCmdIcstDocumentDeleteDocument=@"icstdoc:DeleteDocument";


NSString *const kEnumIcstDocumentDocTypeENDSESSION = @"ENDSESSION";
NSString *const kEnumIcstDocumentDocTypeSMARTPLUG = @"SMARTPLUG";
NSString *const kEnumIcstDocumentDocTypeFIRMWARE = @"FIRMWARE";


@implementation IcstDocumentCapability
+ (NSString *)namespace { return @"icstdoc"; }
+ (NSString *)name { return @"IcstDocument"; }

+ (NSDate *)getCreatedFromModel:(IcstDocumentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstDocumentCapabilityLegacy getCreated:modelObj];
  
}


+ (NSString *)getIdFromModel:(IcstDocumentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstDocumentCapabilityLegacy getId:modelObj];
  
}


+ (NSString *)getDocTypeFromModel:(IcstDocumentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstDocumentCapabilityLegacy getDocType:modelObj];
  
}

+ (NSString *)setDocType:(NSString *)docType onModel:(IcstDocumentModel *)modelObj {
  [IcstDocumentCapabilityLegacy setDocType:docType model:modelObj];
  
  return [IcstDocumentCapabilityLegacy getDocType:modelObj];
  
}


+ (NSString *)getDocumentFromModel:(IcstDocumentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstDocumentCapabilityLegacy getDocument:modelObj];
  
}

+ (NSString *)setDocument:(NSString *)document onModel:(IcstDocumentModel *)modelObj {
  [IcstDocumentCapabilityLegacy setDocument:document model:modelObj];
  
  return [IcstDocumentCapabilityLegacy getDocument:modelObj];
  
}


+ (NSDate *)getModifiedFromModel:(IcstDocumentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstDocumentCapabilityLegacy getModified:modelObj];
  
}


+ (NSString *)getModifiedByFromModel:(IcstDocumentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstDocumentCapabilityLegacy getModifiedBy:modelObj];
  
}


+ (NSString *)getVersionFromModel:(IcstDocumentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstDocumentCapabilityLegacy getVersion:modelObj];
  
}


+ (BOOL)getApprovedFromModel:(IcstDocumentModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IcstDocumentCapabilityLegacy getApproved:modelObj] boolValue];
  
}


+ (NSString *)getApprovedByFromModel:(IcstDocumentModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [IcstDocumentCapabilityLegacy getApprovedBy:modelObj];
  
}

+ (NSString *)setApprovedBy:(NSString *)approvedBy onModel:(IcstDocumentModel *)modelObj {
  [IcstDocumentCapabilityLegacy setApprovedBy:approvedBy model:modelObj];
  
  return [IcstDocumentCapabilityLegacy getApprovedBy:modelObj];
  
}




+ (PMKPromise *) createDocumentWithId:(NSString *)id withDocType:(NSString *)docType withDocument:(NSString *)document onModel:(IcstDocumentModel *)modelObj {
  return [IcstDocumentCapabilityLegacy createDocument:modelObj id:id docType:docType document:document];

}


+ (PMKPromise *) approveDocumentOnModel:(IcstDocumentModel *)modelObj {
  return [IcstDocumentCapabilityLegacy approveDocument:modelObj ];
}


+ (PMKPromise *) rejectDocumentOnModel:(IcstDocumentModel *)modelObj {
  return [IcstDocumentCapabilityLegacy rejectDocument:modelObj ];
}


+ (PMKPromise *) listDocumentMetadataWithDocType:(NSString *)docType onModel:(IcstDocumentModel *)modelObj {
  return [IcstDocumentCapabilityLegacy listDocumentMetadata:modelObj docType:docType];

}


+ (PMKPromise *) deleteDocumentOnModel:(IcstDocumentModel *)modelObj {
  return [IcstDocumentCapabilityLegacy deleteDocument:modelObj ];
}

@end
