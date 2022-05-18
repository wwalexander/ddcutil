#import <IOKit/i2c/IOI2CInterface.h>

typedef CFTypeRef IOAVServiceRef;
extern IOAVServiceRef IOAVServiceCreate(CFAllocatorRef allocator);
extern IOAVServiceRef IOAVServiceCreateWithService(CFAllocatorRef allocator, io_service_t service);
extern IOReturn IOAVServiceWriteI2C(IOAVServiceRef service, uint32_t chipAddress, uint32_t dataAddress, void* inputBuffer, uint32_t inputBufferSize);
extern IOReturn IOAVServiceCopyEDID(IOAVServiceRef service, CFDataRef* x1);
extern IOReturn IOAVServiceReadI2C(IOAVServiceRef service, uint32_t chipAddress, uint32_t offset, void* outputBuffer, uint32_t outputBufferSize);

//#import <Foundation/Foundation.h>
//#import <CoreGraphics/CoreGraphics.h>

//extern CFDictionaryRef CoreDisplay_DisplayCreateInfoDictionary(CGDirectDisplayID);

//extern void DisplayServicesBrightnessChanged(CGDirectDisplayID display, double brightness);
//extern int DisplayServicesGetBrightness(CGDirectDisplayID display, float *brightness);
//extern int DisplayServicesSetBrightness(CGDirectDisplayID display, float brightness);
//extern int DisplayServicesGetLinearBrightness(CGDirectDisplayID display, float *brightness);
//extern int DisplayServicesSetLinearBrightness(CGDirectDisplayID display, float brightness);

//extern void CGSServiceForDisplayNumber(CGDirectDisplayID display, io_service_t* service);

//@class NSString;

//@protocol OSDUIHelperProtocol
//- (void)showFullScreenImage:(long long)arg1 onDisplayID:(unsigned int)arg2 priority:(unsigned int)arg3 msecToAnimate:(unsigned int)arg4;
//- (void)fadeClassicImageOnDisplay:(unsigned int)arg1;
//- (void)showImageAtPath:(NSString *)arg1 onDisplayID:(unsigned int)arg2 priority:(unsigned int)arg3 msecUntilFade:(unsigned int)arg4 withText:(NSString *)arg5;
//- (void)showImage:(long long)arg1 onDisplayID:(unsigned int)arg2 priority:(unsigned int)arg3 msecUntilFade:(unsigned int)arg4 filledChiclets:(unsigned int)arg5 //totalChiclets:(unsigned int)arg6 locked:(BOOL)arg7;
//- (void)showImage:(long long)arg1 onDisplayID:(unsigned int)arg2 priority:(unsigned int)arg3 msecUntilFade:(unsigned int)arg4 withText:(NSString *)arg5;
//- (void)showImage:(long long)arg1 onDisplayID:(unsigned int)arg2 priority:(unsigned int)arg3 msecUntilFade:(unsigned int)arg4;
//@end

//@class NSXPCConnection;

//@interface OSDManager : NSObject <OSDUIHelperProtocol>
//{
//    id <OSDUIHelperProtocol> _proxyObject;
//    NSXPCConnection *connection;
//}

//+ (id)sharedManager;
//@property(retain) NSXPCConnection *connection; // @synthesize connection;
//- (void)showFullScreenImage:(long long)arg1 onDisplayID:(unsigned int)arg2 priority:(unsigned int)arg3 msecToAnimate:(unsigned int)arg4;
//- (void)fadeClassicImageOnDisplay:(unsigned int)arg1;
//- (void)showImageAtPath:(id)arg1 onDisplayID:(unsigned int)arg2 priority:(unsigned int)arg3 msecUntilFade:(unsigned int)arg4 withText:(id)arg5;
//- (void)showImage:(long long)arg1 onDisplayID:(unsigned int)arg2 priority:(unsigned int)arg3 msecUntilFade:(unsigned int)arg4 filledChiclets:(unsigned int)arg5 //totalChiclets:(unsigned int)arg6 locked:(BOOL)arg7;
//- (void)showImage:(long long)arg1 onDisplayID:(unsigned int)arg2 priority:(unsigned int)arg3 msecUntilFade:(unsigned int)arg4 withText:(id)arg5;
//- (void)showImage:(long long)arg1 onDisplayID:(unsigned int)arg2 priority:(unsigned int)arg3 msecUntilFade:(unsigned int)arg4;
//@property(readonly) id <OSDUIHelperProtocol> remoteObjectProxy; // @dynamic remoteObjectProxy;

//@end
