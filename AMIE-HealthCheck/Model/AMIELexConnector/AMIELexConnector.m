//
//  AMIELexConnector.m
//  AMIE-HealthCheck
//
//  Created by Abilash Cumulations on 04/10/17.
//  Copyright © 2017 Abilash. All rights reserved.
//

#import "AMIELexConnector.h"
#import "JSQMessage.h"


@interface AMIELexConnector()<AWSLexMicrophoneDelegate, AWSLexInteractionDelegate>
{
   AWSTaskCompletionSource *textModeSwitchingCompletion;

    MessageData *message;
    JSQMessage *jsqMessage;
    NSString *lastMessageSent;
}
@end

static NSString *AWSLexVoiceButtonIdentifierKey = @"AWSLexVoiceButton";
static NSString *AWSLexChatConfigIdentifierKey = @"chatConfig";

@implementation AMIELexConnector
+ (AMIELexConnector *)connector
{
    static AMIELexConnector *connector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connector = [AMIELexConnector new];
        [connector defaultAppAWSLex];
    });
    return connector;
}

- (void)defaultAppAWSLex
{
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:CognitoRegionType
                                                          identityPoolId:CognitoIdentityPoolId];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:LexRegionType credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    AWSLexInteractionKitConfig *voiceconfig = [AWSLexInteractionKitConfig defaultInteractionKitConfigWithBotName:BotName botAlias:BotAlias];
    
    [AWSLexInteractionKit registerInteractionKitWithServiceConfiguration:configuration interactionKitConfiguration:voiceconfig forKey:AWSLexVoiceButtonIdentifierKey];
    
    AWSLexInteractionKitConfig *chatConfig = [AWSLexInteractionKitConfig defaultInteractionKitConfigWithBotName:BotName botAlias:BotAlias];
    chatConfig.autoPlayback = YES;
    
    [AWSLexInteractionKit registerInteractionKitWithServiceConfiguration:configuration interactionKitConfiguration:chatConfig forKey:AWSLexChatConfigIdentifierKey];
}
- (void)initlizeAWSLexinteractionKit
{
    self.interactionKit = [AWSLexInteractionKit interactionKitForKey:AWSLexChatConfigIdentifierKey];
    self.interactionKit.interactionDelegate = self;
}

- (void)sendMessage:(MessageData *)message withCompletionBlock:(void(^)(id result))messageReturnCompletion
{

    _messageResponseCompletion = messageReturnCompletion;
    [self.interactionKit textInTextOut:message.text];
}


- (void)sendJSQMessage:(NSString *)message withCompletionBlock:(void(^)(JSQMessage*  result))messageReturnCompletion
{
    message = [message stringByReplacingOccurrencesOfString:@"/" withString:@""];
    message = [message stringByReplacingOccurrencesOfString:@"?" withString:@""];
    lastMessageSent = message;
    _messageResponseCompletion = messageReturnCompletion;
    [self.interactionKit textInTextOut:message];
}

- (void)formOutputResponse:(NSString *)message
{
    message = [Utilities getActualText:message];
    if ([message containsString:@"atrial"]) {
        jsqMessage = [[JSQMessage alloc] initWithSenderId:BotName
                                        senderDisplayName:BotName
                                                     date:[[NSDate alloc]init]
                                                     text:message ViewType:@"Link" content:[Utilities AtrialFibrillation]];
    }else if ([message containsString:@"American Heart Association"]) {
        jsqMessage = [[JSQMessage alloc] initWithSenderId:BotName
                                        senderDisplayName:BotName
                                                     date:[[NSDate alloc]init]
                                                     text:message ViewType:@"Link" content:[Utilities HeartFailure]];
    }
    else if ([message containsString:@"call"] || [message containsString:@"contact"]) {
        jsqMessage = [[JSQMessage alloc] initWithSenderId:BotName
                                        senderDisplayName:BotName
                                                     date:[[NSDate alloc]init]
                                                     text:message ViewType:@"Call" content:[Utilities CustomerCare]];
        
    }else if ([message containsString:@"more information"] || [message containsString:@"contact"]) {
        jsqMessage = [[JSQMessage alloc] initWithSenderId:BotName
                                        senderDisplayName:BotName
                                                     date:[[NSDate alloc]init]
                                                     text:message ViewType:@"Call" content:[Utilities MoreInformation]];
        
    }else
    {
        jsqMessage = [[JSQMessage alloc] initWithSenderId:BotName
                                        senderDisplayName:BotName
                                                     date:[[NSDate alloc]init]
                                                     text:message.length > 0 ? message : @"Sorry can you repeat that again?"];
    }
    if (_messageResponseCompletion != nil ) {
        _messageResponseCompletion(jsqMessage);
    }
}
#pragma mark InteractionKit

- (void)interactionKit:(AWSLexInteractionKit *)interactionKit
               onError:(NSError *)error{
    NSLog(@"error occured %@", error);
}

- (void)interactionKit:(AWSLexInteractionKit *)interactionKit
       switchModeInput:(AWSLexSwitchModeInput *)switchModeInput
      completionSource:(AWSTaskCompletionSource<AWSLexSwitchModeResponse *> *)completionSource{
    
    self.sessionAttributes = switchModeInput.sessionAttributes;
    message = nil;
    jsqMessage = nil;
    NSString *message = [Utilities getActualText:switchModeInput.outputText];
    if(message.length == 0)
    {
        [self sendJSQMessage:lastMessageSent withCompletionBlock:_messageResponseCompletion];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        message = [[MessageData alloc] initWithMessageType:PlainTextMessage withText:switchModeInput.outputText incoming:true withLink:@"" withAvathar:[UIImage imageNamed:@"defaultAvatar"]];

        [self formOutputResponse:switchModeInput.outputText];
    });
    //this can expand to take input from user.
    AWSLexSwitchModeResponse *switchModeResponse = [AWSLexSwitchModeResponse new];
    [switchModeResponse setInteractionMode:AWSLexInteractionModeText];
    [switchModeResponse setSessionAttributes:switchModeInput.sessionAttributes];
    [completionSource setResult:switchModeResponse];
    
}

- (void)interactionKitContinueWithText:(AWSLexInteractionKit *)interactionKit
                      completionSource:(AWSTaskCompletionSource<NSString *> *)completionSource{
    textModeSwitchingCompletion = completionSource;
}

- (void)voiceButton:(AWSLexVoiceButton *)button onResponse:(nonnull AWSLexVoiceButtonResponse *)response{
    // `inputranscript` is the transcript of the voice input to the operation
    NSLog(@"Input Transcript: %@", response.inputTranscript);
    //self.input.text = [NSString stringWithFormat:@"\"%@\"", response.inputTranscript];
    NSLog(@"on text output %@", response.outputText);
    //self.output.text = response.outputText;
    jsqMessage = [[JSQMessage alloc] initWithSenderId:SenderID
                                    senderDisplayName:SenderName
                                                 date:[[NSDate alloc]init]
                                                 text:response.inputTranscript.length > 0 ? response.inputTranscript : @"Can't reach your voice"];
    if (_messageResponseCompletion != nil ) {
        _messageResponseCompletion(jsqMessage);
    }
    
    [self formOutputResponse:response.outputText];
}

- (void)voiceButton:(AWSLexVoiceButton *)button onError:(NSError *)error{
    NSLog(@"error %@", error);
}



@end
