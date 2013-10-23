
@import <Foundation/CPObject.j>

// @protocol PWyliodrinLink

// - (void)wyliodrinLink:(id)link didReceiveData:(var)jsonObject;
// - (void)wyliodrinLink:(id)link didFailWithError:(id)error;

// @end

@implementation WyliodrinLink : CPObject
{
	CPURLConnection urlconnection;
	CPURLRequest  request;
	id delegate;
	id datastr;
}

- (id) initWithURLAndJSON:(CPString)url JSON:(var)data delegate:(id)wdelegate
{
	self = [super init];
	if (self != nil)
	{
		var json = JSON.stringify (data);
		delegate = wdelegate;
		request = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:url]];
		[request setHTTPMethod:@"POST"];
		[request setHTTPBody:json];
		[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
		[request setValue:json.length forHTTPHeaderField:@"Content-Length"];

		urlconnection = [[CPURLConnection alloc] initWithRequest:request delegate:self];
		datastr = @"";
		// [urlconnection start];
		CPLog (@"connectiong");
	}
	return self;
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
