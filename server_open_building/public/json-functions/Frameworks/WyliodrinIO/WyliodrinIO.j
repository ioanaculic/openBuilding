
@import <Foundation/CPObject.j>

// @protocol PWyliodrinIO

// - (void)wyliodrinIOConnected:(id)io;
// - (void)wyliodrinIODisconnected:(id)io;
// - (void)wyliodrinIOClose:(id)io;
// - (void)wyliodrinIODidReceiveTag:(CPString)tag data:(id)jsonObject;

// @end

@implementation WyliodrinIO : CPObject
{
	var socketio @accessors;
	var delegate @accessors;
	CPMutableArray tags @accessors;
}

- (id) initWithDelegate:(id)wdelegate
{
	self = [super init];
	if (self != nil)
	{
		self.socketio = nil;
		self.tags = [[CPMutableArray alloc] init];
		self.delegate = wdelegate;
		[self connect];
	}
	return self;
}

- (void) connect
{
	if (!self.socketio)
	{
		self.socketio = io.connect('/');
		self.socketio.on ('connect', function ()
		{
			CPLog (@"WyliodrinIO connected")
			for (i=0; i<[self.tags count]; i++)
			{
				tag = [self.tags objectAtIndex:i];
				self.socketio.on (tag, function (jsonData)
				{
					[self.delegate wyliodrinIODidReceiveTag:tag data:jsonData];
				});
			}
			[self.delegate wyliodrinIOConnected:self];
		});
		self.socketio.on ('disconnect', function ()
		{
			CPLog (@"WyliodrinIO disconnected");
			[self.delegate wyliodrinIODisconnected:self];
			// self.socketio = nil;
		});
		self.socketio.on ('close', function ()
		{
			CPLog (@"WyliodrinIO closed");
			[self.delegate wyliodrinIODisconnected:self];
			self.socketio = nil;
		});
		CPLog (@"WyliodrinIO connectiong");
	}
	else
	{
		CPLog (@"WyliodrinIO already connected");
	}
}

- (void) disconnect
{
	if (self.socketio)
	{
		self.socketio._events = {};
		self.socketio.disconnect ();
		CPLog (@"WyliodrinIO disconnecting");
	}
	else
	{
		CPLog (@"WyliodrinIO already disconnected");
	}
}

- (void) addTag:(CPString)tag
{
	add = YES;
	for (i=0; i<[self.tags count]; i++)
	{
		s = [self.tags objectAtIndex:i];
		if ([s isEqual:tag])
		{
			add = NO;
		}
	}
	if (add == YES) [self.tags addObject: tag];
	if (self.socketio)
	{
		self.socketio.on (tag, function (jsonData)
		{
			[self.delegate wyliodrinIODidReceiveTag:tag data:jsonData];
		});
	}
}

- (void) send:(CPString)tag JSON:(var)jsonObject
{
	if (self.socketio)
	{
		CPLog (@"WyliodrinIO sending tag "+tag);
		self.socketio.emit (tag, jsonObject);
	}
	else
	{
		CPLog (@"WyliodrinIO send error disconnected");
	}
}

-(void)connection:(CPURLConnection)connection didReceiveData:(CPData)data
{
    CPLog (@"data: "+data);
    datastr = datastr+data;
}

-(void)connectionDidFinishLoading:(CPURLConnection)connection
{
	CPLog (@"load finished");
	if (delegate!=nil)
    {
    	try
    	{
    		[delegate wyliodrinLink:self didReceiveData:[[datastr string] objectFromJSON]];
    	}
    	catch (e)
    	{
    		[delegate wyliodrinLink:self didFailWithError:datastr];
    	}
    }
}

-(void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
    CPLog (@"error: "+error);
    if (delegate!=nil) [delegate wyliodrinLink:self didFailWithError:error];
}

@end
