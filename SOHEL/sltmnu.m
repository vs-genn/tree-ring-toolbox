function k = sltmnu(s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,...
                    s17,s18,s19,s20,s21,s22,s23,s24,s25,s26,s27,s28,s29,s30,s31,s32);
%
% USAGE : K = MENU('Choose a color','Red','Blue','Green')
%   MENU generates a menu of choices on the screen 
%   for user input.
%
%	Choose a color
%
%	     Red
%	     Blue
%	     Green
%
% Pressing a button on the menu window by the user returns the 
% sequence number of the choice.  On machines that support it, 
% the local menu system is used.
%
% The maximum number of menu items is 32.
%
% S. Anwar 6/17/94, revised 6/20/94 by SA.
% Copyright (c) 1994 by Control Solutions, Inc.
%________________________________________________________________

c = computer;
display = 1;
PC = strcmp(c(1:2),'PC');
if ~strcmp(c(1:2),'PC') & ~strcmp(c(1:2),'MA')
% might be unix or VMS
	if isunix
		display = length(getenv('DISPLAY')) > 0;
	else
		display = length(getenv('DECW$DISPLAY')) > 0;
	end
end
if ~display
	disp(' ')
	disp(['----- ',s0,' -----'])
	disp(' ')
	for i=1:(nargin-1)
	    disp(['      ',int2str(i),') ',eval(['s',int2str(i)])])
	end
	disp(' ')
	k = input('Select a menu number: ');
	return
end

global MENU_VARIABLE;
MENU_VARIABLE = 0;
xedge = 30;
yedge = 35;
ybord = 30;
width = 30;
avwidth = 7; % actually 6.8886 +/- 0.4887
height = 30;
imax = 1;
maxlen = length(s0);
for i = 1:nargin-1
    mx = length(eval(['s',int2str(i)]));
    if mx > maxlen
       maxlen = mx;
       imax = i;
    end
end
twidth = 1.2*maxlen*avwidth;
% now figure out total dimensions needed so things can get placed in pixels
mwwidth = twidth + width + 2*xedge;
mwheight = (nargin+1)*yedge;
ss = get(0,'ScreenSize');
swidth = ss(3); sheight = ss(4);
%left = (swidth-mwwidth)/2;
left = 20;
bottom = sheight-mwheight-ybord;
rect = [left bottom mwwidth mwheight];
fig = figure('Position',rect,'number','off','name',' ','resize','off',...
      'menubar','none','Color','white');   
set(gca,'Position',[0 0 1 1]); axis off;
% Place title
t = text(mwwidth/2,mwheight-yedge/2,s0,'Horizontal','center','Vertical','top','units','pixels');
set(t,'Color','k');
set(t,'FontWeight','Bold');
t = text(mwwidth/2,mwheight-yedge,s1,'Horizontal','center','Vertical','top','units','pixels');
set(t,'Color','k');
set(t,'FontWeight','Bold');
for ii=(nargin-1):-1:2
    i = nargin - ii;
    h1 = uicontrol('position',[xedge  (i-.5)*yedge width+twidth height]);
    set(h1,'callback',['global MENU_VARIABLE,MENU_VARIABLE = ',int2str(ii),';']);
    set(h1,'string',['  ', eval(['s',int2str(ii)])])
    set(h1,'HorizontalAlignment','left');
% left justify string inside button
end
while MENU_VARIABLE == 0
	if PC
		waitforbuttonpress;
	else
		drawnow;
	end
end
k = MENU_VARIABLE;
delete(fig)

% End of file
