

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class IcstDocumentModel;





/** The date the document was created */
extern NSString *const kAttrIcstDocumentCreated;

/** unique id */
extern NSString *const kAttrIcstDocumentId;

/** The type of document */
extern NSString *const kAttrIcstDocumentDocType;

/** The gzipped, B64 version of the text document */
extern NSString *const kAttrIcstDocumentDocument;

/** The last date the document was modified */
extern NSString *const kAttrIcstDocumentModified;

/** agent id that last modified the document */
extern NSString *const kAttrIcstDocumentModifiedBy;

/** version of the document */
extern NSString *const kAttrIcstDocumentVersion;

/** true if the document has been approved, set to false when created */
extern NSString *const kAttrIcstDocumentApproved;

/** agent id that should approve the document (if approved is false) or did approve the document (if approved is true). The agent making the changes sets this field to indicate the document is ready for review. */
extern NSString *const kAttrIcstDocumentApprovedBy;


extern NSString *const kCmdIcstDocumentCreateDocument;

extern NSString *const kCmdIcstDocumentApproveDocument;

extern NSString *const kCmdIcstDocumentRejectDocument;

extern NSString *const kCmdIcstDocumentListDocumentMetadata;

extern NSString *const kCmdIcstDocumentDeleteDocument;


extern NSString *const kEnumIcstDocumentDocTypeENDSESSION;
extern NSString *const kEnumIcstDocumentDocTypeSMARTPLUG;
extern NSString *const kEnumIcstDocumentDocTypeFIRMWARE;


@interface IcstDocumentCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSDate *)getCreatedFromModel:(IcstDocumentModel *)modelObj;


+ (NSString *)getIdFromModel:(IcstDocumentModel *)modelObj;


+ (NSString *)getDocTypeFromModel:(IcstDocumentModel *)modelObj;

+ (NSString *)setDocType:(NSString *)docType onModel:(Model *)modelObj;


+ (NSString *)getDocumentFromModel:(IcstDocumentModel *)modelObj;

+ (NSString *)setDocument:(NSString *)document onModel:(Model *)modelObj;


+ (NSDate *)getModifiedFromModel:(IcstDocumentModel *)modelObj;


+ (NSString *)getModifiedByFromModel:(IcstDocumentModel *)modelObj;


+ (NSString *)getVersionFromModel:(IcstDocumentModel *)modelObj;


+ (BOOL)getApprovedFromModel:(IcstDocumentModel *)modelObj;


+ (NSString *)getApprovedByFromModel:(IcstDocumentModel *)modelObj;

+ (NSString *)setApprovedBy:(NSString *)approvedBy onModel:(Model *)modelObj;





/** Add a document to the support_document_versions table with approved set to false. The &#x27;modifiedBy&#x27; and &#x27;version&#x27; attributes are autoset. */
+ (PMKPromise *) createDocumentWithId:(NSString *)id withDocType:(NSString *)docType withDocument:(NSString *)document onModel:(Model *)modelObj;



/** Promote a document to the support_documents table. The document will also still be in the support_document_versions table. &#x27;approved&#x27; is autoset, &#x27;approvedBy&#x27; is already set. */
+ (PMKPromise *) approveDocumentOnModel:(Model *)modelObj;



/** Reject an unapproved document by setting &#x27;approvedBy&#x27; to null. The &#x27;modifiedBy&#x27; field will not be changed (otherwise this would just be a SetAttributes call). */
+ (PMKPromise *) rejectDocumentOnModel:(Model *)modelObj;



/** Retrieves a list of document info without the documents themselves. */
+ (PMKPromise *) listDocumentMetadataWithDocType:(NSString *)docType onModel:(Model *)modelObj;



/** Removes a document. Only allowed if the document has not been approved. */
+ (PMKPromise *) deleteDocumentOnModel:(Model *)modelObj;



@end
