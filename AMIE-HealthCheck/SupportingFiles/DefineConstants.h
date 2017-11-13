//
//  DefineConstants.h
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 11/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#ifndef DefineConstants_h
#define DefineConstants_h

#define kGCMMessageIDKey @"gcm.message_id"
//User defaults constants
#define DEVICETOKEN @"TOKEN"
#define FCMTOKEN @"FCMTOKEN"
#define USERID @"USERID"
#define REGISTEREDSUCCESS @"REGISTERED"
#define MESSAGEINDEX @"MESSAGEINDEX"


//REST API
#define REGISTRATIONAPI @"app/register"
#define FCM_TOKENAPI @"app/fcm-token"

//JSON KEYS
#define statusKey @"status"
#define resultKey @"result"
#define recordsKey @"records"
#define user_idKey @"user_id"

//Notification keys
#define RECEIVEMESSAGEKEY @"RECEIVEMESSAGEKEY"
#define SUCCESS @"success"

//scenario messages
//#define SCENARIO1 @"Good Morning Salvatore! I noticed you haven’t logged your medication yet. Did you take your Xarelto this morning?"//@"Good Morning, I noticed you’ve stopped taking your Xarelto. Is there a reason why you’ve stopped taking your medication?"
//#define SCENARIO2 @"Good Morning Salvatore! You’re doing a great job staying consistent with your medication. How do you feel since you started taking Xarelto?"//@"Good Morning, Did you take your Xarelto this morning ?"
//
//#define SCENARIO3 @"Good Morning Salvatore! I noticed you’ve stopped taking your Xarelto. Is there a reason why you’ve stopped?"//@"Good Morning, How are you doing today? Please call Dr. Caldwell’s office and set up an appointment for any help."

#define SCENARIO1 @"Good Morning Salvatore! Did you take your Entresto this morning?"//@"Good Morning, I noticed you’ve stopped taking your Xarelto. Is there a reason why you’ve stopped taking your medication?"
#define SCENARIO2 @"Good morning Salvatore! You’re doing a great job taking Entresto on time. Why do you continue taking Entresto?"//@"Good Morning, Did you take your Xarelto this morning ?"

#define SCENARIO3 @"Good Morning Salvatore! I noticed you’ve stopped taking your Entresto. Is there a reason why you’ve stopped taking your medication?"//@"Good Morning, How are you doing today? Please call Dr. Caldwell’s office and set up an appointment for any help."

#define SIDEEFFECTS @"What kind of side effects"

#define REASON @"Is there a reason"

#define SenderName  @"ABI"//@"Amie";//@"OrderFlowers";
#define SenderID  [USERDEFAULT valueForKey:USERID] != nil ? [USERDEFAULT valueForKey:USERID] : @"DefaultID"


#define STORYBOARD(B) [UIStoryboard storyboardWithName:B bundle:nil]
#define USERDEFAULT  [NSUserDefaults standardUserDefaults]
#define USERSYNC  [USERDEFAULT synchronize]
#define APPDELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate

#endif /* DefineConstants_h */
