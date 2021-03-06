function recinp
%
% USAGE : recinp
%   Reads a data file in '.rec' format. The file must have the following 
%   format : 3 rows above each block data matrix contain strings. Each 
%   block data matrix is of size (m x n). Saves the full data matrix, 
%   Data ID matrix, and a text matrix in a user specified .mat file.
%
% NO INPUTS
%
% NO OUTPUTS
%
% USER WRITTEN FUNCTIONS NEEDED
%------------------------------
% UDISP.M : A user interactive graphic display function
% JDISP.M : A non-interactive graphic display function
%
% FILES PRODUCED
% --------------
% ?.MAT		A .mat file with user given name. Contains 
%		a data matrix, a data ID matrix, and a text
%		matrix explaining different columns of the 
%		data ID matrix.
%________________________________________________________
    
global fln; % Must be able to find the file in global space

% Allocate
T= zeros(154,16);  % numeric info in reconstructions
R=[];

% Prompt for data file name
fln=uigetfile('*.rec','INPUT filename');

% If Cancel button is pressed in the input window, flag is 
% set to -1 and control is returned to calling function
if fln==0,
  fl=-1;
  return;
end 

% Check for existence of the input file name
while ~exist(fln),
  fln=uigetfile('*.dat','Enter Correct filename');
end
jh=jdisp(['Reading the file: ',fln,'. Please wait ... ']); 
pause(1);

% Standard data block size of .rec files
m=28;	% Row size of each block of data
n=11;	% Column size of each block of data

% Open the data file for reading
fid=fopen(fln,'r');

% Read the first 4 lines before the data; these lines contain 
% text strings

ln1=fgetl(fid);

T(1,1:3)=[str2num(ln1(19:21)) str2num(ln1(32:35)) str2num(ln1(45:48))];

ln2=fgetl(fid);
s1 = [str2num(ln2(16:19)) str2num(ln2(21:24)) str2num(ln2(43:46))];
s2 = [str2num(ln2(48:51)) str2num(ln2(72:75)) str2num(ln2(77:80))];
T(1,4:9)=[s1 s2];

ln3=fgetl(fid);
s3 = [str2num(ln3(7:10)) str2num(ln3(20:23)) str2num(ln3(33:36))];
s4 = [str2num(ln3(45:48)) str2num(ln3(56:59)) str2num(ln3(69:72))];
s5 = [str2num(ln3(82:85))];
T(1,10:16)=[s3 s4 s5];
k=0;


while 1, 

  % Read rest of the data file in %g format block by block k+1
  % and store the data block in R matrix

  k=k+1;
  disp(['Data for k=',int2str(k)]);
  zv=fscanf(fid,'%g',[n,m]);

  if isempty(zv),	% Stop reading if end of file is reached
    break;
  end

  yrv=zv(1,:);
  zv(1,:)=[];
  zv=zv(:);
  R=[R zv];

  % Read the 4 lines before the data; Put these lines in 
  % appropriate string matrices 

  ln1=fgetl(fid);
  ln2=fgetl(fid);
  ln3=fgetl(fid);

  if k >= 153
   break
  end

  s0=[str2num(ln1(18:20))  str2num(ln1(31:34))  str2num(ln1(45:48))];
 
  s1 = [str2num(ln2(16:19)) str2num(ln2(21:24)) str2num(ln2(43:46))];
  s2 = [str2num(ln2(48:51)) str2num(ln2(72:75)) str2num(ln2(77:80))];
  s3 = [str2num(ln3(7:10)) str2num(ln3(20:23)) str2num(ln3(33:36))];
  s4 = [str2num(ln3(45:48)) str2num(ln3(56:59)) str2num(ln3(69:72))];
  s5 = [str2num(ln3(82:85))];

  T(k+1,1:16)=[s0 s1 s2 s3 s4 s5];

end


LM=T;

% A text matrix containing the column info about the data 
% ID matrix LM is made as follows :

txtm=['LM - Numeric matrix of Information';...
      '     on .dat File                 ';...
      'COL 1  : GRID POINT #             ';...
      'COL 2  : LATITUDE                 ';...
      'COL 3  : LONGITUDE                ';...
      'COL 4  : CALIB BEGIN              ';...
      'COL 5  : CALIB END                ';...
      'COL 6  : VERIF BEGIN              ';...
      'COL 7  : VERIF END                ';...
      'COL 8  : RECON BEGIN              ';...
      'COL 9  : RECON END                ';...
      'COL 10 : RSQ                      ';...
      'COL 11 : ARSQ                     ';...
      'COL 12 : ERE                      ';...
      'COL 13 : PR                       ';...
      'COL 14 : SR                       ';...
      'COL 15 : RE                       ';...
      'COL 16 : CE                       ';...
      '                                  ';...
      'R - TSM, Year in Column 1, Grid   ';...
      ' point values in remaining columns'];
 
% Make the continuous year vector and make the final data matrix
yrv=(yrv(1):yrv(m)+9)';
R=[yrv R];

% Prompt for the output file name and save data matrix R, data 
% ID matrix LM and text matrix txtm in the specified .mat file
filnam=uiputfile('*.mat','Save in MAT file ?');
eval(['save ' filnam ' R ' ' LM ' ' txtm ']);

close(jh);
jhdl=jdisp(['Successful Reading of the data file ' fln]);
pause(2);
close(jhdl);	% close the jdisp window

fclose(fid);  	% close the input file


% End of file
