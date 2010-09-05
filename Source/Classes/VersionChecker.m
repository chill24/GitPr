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

#import "VersionChecker.h"

@interface VersionChecker (Private)
- (void) connection:(NSURLConnection *)conn didReceiveData:(NSData *)data;
- (void) connection:(NSURLConnection *)conn didFailWithError:(NSError *)error;
- (void) connectionDidFinishLoading:(NSURLConnection *)conn;
- (void) newBuildAvailable;
@end

@implementation VersionChecker

- (id) init {
	self = [super init];
	if (!self)
		return nil;

	NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mumble-ios.appspot.com/latest.plist"]];
	_conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	_buf = [[NSMutableData alloc] init];

	return self;
}

- (void) dealloc {
	[_conn cancel];
	[_conn release];
	[_buf release];
	[super dealloc];
}

- (void) connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
	[_buf appendData:data];
}

- (void) connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
	NSLog(@"Failed to fetch latest version info.");
}

- (void) connectionDidFinishLoading:(NSURLConnection *)conn {
	NSPropertyListFormat fmt = NSPropertyListXMLFormat_v1_0;
	NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:_buf options:0 format:&fmt error:nil];
	if (dict) {
		NSBundle *mainBundle = [NSBundle mainBundle];
		NSString *ourRev = [mainBundle objectForInfoDictionaryKey:@"MumbleGitRevision"];
		NSString *latestRev = [dict objectForKey:@"MumbleGitRevision"];
		if ([ourRev isEqualToString:latestRev]) {
			NSDate *ourBuildDate = [mainBundle objectForInfoDictionaryKey:@"MumbleBuildDate"];
			NSDate *latestBuildDate = [dict objectForKey:@"MumbleBuildDate"];
			if ([ourBuildDate isEqualToDate:latestBuildDate]) {
				// Running the latest build
			} else {
				NSDate *latest = [ourBuildDate laterDate:latestBuildDate];
				if (latestBuildDate == latest) {
					// New build available
					[self newBuildAvailable];
				} else {
					// Running an unreleased build
				}
			}
		}
	}
}

- (void) newBuildAvailable {
	NSString *title = @"New beta build available";
	NSString *msg = @"A new beta build is available from the beta portal.\n\nPlease update when time permits.";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
