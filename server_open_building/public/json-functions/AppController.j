/*
 * AppController.j
 * json-functions
 *
 * Created by You on October 7, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <LPKit/LPMultiLineTextField.j>
@import <WyliodrinLink/WyliodrinLink.j>
@import <WyliodrinIO/WyliodrinIO.j>
@import <XTermKit/XTermKit.j>


@implementation AppController : CPObject
{
    CPTextField requrl @accessors;
    LPMultiLineTextField req @accessors;
    LPMultiLineTextField res @accessors;

    CPButton buttonreq;

    CPTextField reqsurl @accessors;
    LPMultiLineTextField reqs @accessors;
    LPMultiLineTextField sres @accessors;

    CPButton buttonsreq;

    var b;
    var s;
    var contentView;

    WyliodrinIO wyliodrinio @accessors;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    // var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];

    // [label setStringValue:@"Hello World!"];
    // [label setFont:[CPFont boldSystemFontOfSize:24.0]];

    // [label sizeToFit];

    // [label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
    // [label setCenter:[contentView center]];

    // [contentView addSubview:label];

    b=0;
    s=30;

    self.requrl = [[CPTextField alloc] initWithFrame: CGRectMake(10, 30, 300, 40)];
    [self.requrl setEditable:YES];
    [self.requrl setBordered:YES];
    [self.requrl setBezeled:YES];

    [contentView addSubview:self.requrl];

    self.req = [[LPMultiLineTextField alloc] initWithFrame: CGRectMake(10, 100, 300, 230)];
    [self.req setEditable:YES];
    [self.req setBordered:YES];
    [self.req setBezeled:YES];
    //[self.req setBordered:YES];
    //[self.req setScrollable: YES];
    [contentView addSubview: self.req];

    self.res = [[LPMultiLineTextField alloc] initWithFrame: CGRectMake(320, 30, 300, 300)];
    [self.res setEditable:YES];
    [self.res setBordered:YES];
    [self.res setBezeled:YES];
    //[self.res setBordered:YES];
    //[self.res setScrollable: YES];
    [contentView addSubview: self.res];

    buttonreq = [[CPButton alloc] initWithFrame:CGRectMake(40, 340, 200, 24)];
    [buttonreq setTitle:@"Req"];

    [buttonreq setTarget:self];
    [buttonreq setAction:@selector(req:)];

    [contentView addSubview: buttonreq];

    self.reqsurl = [[CPTextField alloc] initWithFrame: CGRectMake(710, 30, 300, 40)];
    [self.reqsurl setEditable:YES];
    [self.reqsurl setBordered:YES];
    [self.reqsurl setBezeled:YES];

    [contentView addSubview:self.reqsurl];

    self.reqs = [[LPMultiLineTextField alloc] initWithFrame: CGRectMake(710, 100, 300, 230)];
    [self.reqs setEditable:YES];
    [self.reqs setBordered:YES];
    [self.reqs setBezeled:YES];
    //[self.req setBordered:YES];
    //[self.req setScrollable: YES];
    [contentView addSubview: self.reqs];

    self.sres = [[LPMultiLineTextField alloc] initWithFrame: CGRectMake(1020, 30, 300, 300)];
    [self.sres setEditable:YES];
    [self.sres setBordered:YES];
    [self.sres setBezeled:YES];
    //[self.res setBordered:YES];
    //[self.res setScrollable: YES];
    [contentView addSubview: self.sres];

    buttonsreq = [[CPButton alloc] initWithFrame:CGRectMake(740, 340, 200, 24)];
    [buttonsreq setTitle:@"SReq"];

    [buttonsreq setTarget:self];
    [buttonsreq setAction:@selector(sreq:)];

    [contentView addSubview: buttonsreq];


    [self addButtonName:@"Add location" requrl:@"/add" jsonobject:{name:"",latitude:"",longitude:"",id:[]}];
    [self addButtonName:@"Add floor" requrl:@"/add_floor" jsonobject:
    {
        locationID:"",
        canModify:"",
        nr:"",
        items:[{
            objType:"",
            wallInfo:{
                        x1:"",
                        y1:"",
                        x2:"",
                        y2:""
                    }},
           { objType:"",
            labelInfo:{
                        x:"",
                        y:"",
                        text:""
                    }}]
    }];
    [self addButtonName:@"List Project" requrl:@"/projects/list" jsonobject:{projectid:""}];
    [self addButtonName:@"List Checkpoints" requrl:@"/projects/checkpoints" jsonobject:{projectid:""}];
    [self addButtonName:@"Remove Project" requrl:@"/projects/remove" jsonobject:{projectid:"", projectname:""}];
    [self addButtonName:@"Create Folder" requrl:@"/projects/createfolder" jsonobject:{projectid:"", foldername:""}];
    [self addButtonName:@"Remove Folder" requrl:@"/projects/removefolder" jsonobject:{projectid:"", foldername:""}];
    [self addButtonName:@"Move Folder" requrl:@"/projects/movefolder" jsonobject:{projectid:"", foldername:"", mvfoldername:""}];
    b=0;
    s = 330;
    [self addButtonName:@"Share User" requrl:@"/projects/shareuser" jsonobject:{projectid:"", userid:"", access:""}];
    [self addButtonName:@"Create Source" requrl:@"/projects/createsource" jsonobject:{projectid:"", sourcename:""}];
    [self addButtonName:@"Remove Source" requrl:@"/projects/removesource" jsonobject:{projectid:"", sourcename:""}];
    [self addButtonName:@"Move Source" requrl:@"/projects/movesource" jsonobject:{projectid:"", sourcename:"", mvsourcename:""}];

    /*xterm = [[XTermView alloc] initWithFrame:CGRectMake (10, 100, 300, 200)];
    [contentView addSubview:xterm];*/

    [theWindow orderFront:self];

    // self.wyliodrinio = [[WyliodrinIO alloc] initWithDelegate:self];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

- (void) addButtonName:(CPString)name requrl:(CPString)reqaddress jsonobject:(id)jsonobject
{
    b=b+1;
    var buttonfill = [[CPButton alloc] initWithFrame:CGRectMake(s+10, 400+(25*b), 200, 24)];
    [buttonfill setTitle:name];

    [buttonfill setTarget:self];
    [buttonfill setAction:@selector(fill:)];

    [buttonfill setTag:{requrl:reqaddress, jsonobject:jsonobject}];

    [contentView addSubview: buttonfill];
}

- (void) wyliodrinLink:(id)wyliodrinlink didReceiveData:(var)json
{
    [self.res setStringValue:JSON.stringify (json, null, 4)];
}

- (void) wyliodrinLink:(id)wyliodrinlink didFailWithError:(id)err
{
    // alert (err);
    [self.res setStringValue:err];
}

- (void)fill:(id)sender
{
    var sendertag = [sender tag];
    [self.requrl setStringValue:sendertag.requrl];
    [self.req setStringValue:JSON.stringify (sendertag.jsonobject, null, 2)];
}

- (void)req:(id)sender
{
    // alert ([self.req stringValue]);
    [[WyliodrinLink alloc] initWithURLAndJSON:[self.requrl stringValue] JSON:JSON.parse([self.req stringValue]) delegate:self];
    [self.res setStringValue:@""];
}

- (void)sreq:(id)sender
{
    [self.wyliodrinio send:[self.reqsurl stringValue] JSON:JSON.parse([self.reqs stringValue])];
}

- (void)wyliodrinIOConnected:(id)io
{
    alert ('connected');
}

- (void)wyliodrinIODisconnected:(id)io
{
    alert ('disconnected');
}

- (void)wyliodrinIOClose:(id)io
{
    alert ('close');
}

- (void)wyliodrinIODidReceiveTag:(CPString)tag data:(id)jsonObject
{
    alert ('tag '+JSON.stringify(jsonObject, null, 2));
}

@end
