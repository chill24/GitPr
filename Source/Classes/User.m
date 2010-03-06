/* Copyright (C) 2009-2010 Mikkel Krautz <mikkel@krautz.dk>

   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   - Redistributions of source code must retain the above copyright notice,
     this list of conditions and the following disclaimer.
   - Redistributions in binary form must reproduce the above copyright notice,
     this list of conditions and the following disclaimer in the documentation
     and/or other materials provided with the distribution.
   - Neither the name of the Mumble Developers nor the names of its
     contributors may be used to endorse or promote products derived from this
     software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
   A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "User.h"
#import "RWLock.h"
#import "Channel.h"

@implementation User

- (void) dealloc {
	if (userName)
		[userName release];
	[super dealloc];
}

#pragma mark -

- (NSUInteger) treeDepth {
	return depth;
}

- (void) setTreeDepth:(NSUInteger)treeDepth {
	depth = treeDepth;
}

#pragma mark -

- (void) setSession:(NSUInteger)session {
	userSession = session;
}

- (NSUInteger) session {
	return userSession;
}

- (void) setUserName:(NSString *)name {
	if (userName)
		[userName release];
	userName = [name copy];
}

- (NSString *) userName {
	return userName;
}

- (void) setTalking:(TalkingState)flag {
	talkState = flag;
}

- (TalkingState) talkingState {
	return talkState;
}

- (void) setMute:(BOOL)flag {
	muteState = flag;
}

- (BOOL) muted {
	return muteState;
}

- (void) setDeaf:(BOOL)flag {
	deafState = flag;
}

- (BOOL) deafened {
	return deafState;
}

- (void) setSuppress:(BOOL)flag {
	suppressState = flag;
}

- (BOOL) suppressed {
	return suppressState;
}

- (void) setLocalMute:(BOOL)flag {
	localMuteState = flag;
}

- (BOOL) localMuted {
	return localMuteState;
}

- (void) setSelfMute:(BOOL)flag {
	selfMuteState = flag;
}

- (BOOL) selfMuted {
	return selfMuteState;
}

- (void) setSelfDeaf:(BOOL)flag {
	selfDeafState = flag;
}

- (BOOL) selfDeafened {
	return selfDeafState;
}

- (void) setChannel:(Channel *)chan {
	channel = chan;
}

- (Channel *) channel {
	return channel;
}


@end
