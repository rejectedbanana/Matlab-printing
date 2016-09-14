function printps(fignum, figname, flags)
% printeps(fignum, figname, flags)
% this is a simple function that overrides Matlab's desire to call all
% fonts 'Helvetica' in an exported .eps file. This is particularly annoying
% if you import your file into Illustrator and find that not only do you
% NOT have 'Helvetica', but that in substituting for it, your subscripts 
% have moved a mile away and things otherwise just don't look 'right.'
% It is suggested that you set your default font in a
% startup file to something that you actually have on your system. For
% instance, if you purchased the Helvetica family straight from Adobe,
% set(0, 'DefaultAxesFontName', 'HelveticaLTStd-Roman'); 
% the whole point of this is that when you generate a figure in Matlab,
% you'd like your exported file to be as close a representation of that
% figure as possible. 
% J. Aumentado
% 4/20/05
% Note: This is a global change of font in the file. That is, any text you
% add via text() and title() commands will end up in the default axes font.
% this is because there is no easy way to parse out the fonts of these
% objects in the .eps file for replacement.
%
%
% EXAMPLE:
% set(0, 'DefaultAxesFontName', 'Arial');   %replace fontname with something
%                                           %you have
% figure(1);clf;fplot(@tanh,[-5,5]);        %plot something
% printeps(1,'test');                       %print the contents of figure 1
%                                           %to test.eps.
% edited KIM 11.14 to make EPS cropped to the size I want and added flags
% input

if nargin <3
    flags = '';
end

% get the correct width of the figure
posi = get( fignum, 'position');
ww = posi(3)./72; % width figure in inches
hh = posi(4)./72; % height of paper in inches
set(fignum, 'papersize', [ww, hh], 'paperposition', [0, 0, ww, hh], 'paperpositionmode', 'auto')

figfilestr = [figname '.ps'];
eval(['print -depsc -f' num2str(fignum) ' ' flags ' ' figname ';']);

% now read in the file
fid = fopen(figfilestr);
ff = char(fread(fid))';
fclose(fid);

%get the actual font
figure(fignum);
actualfont = get(gca,'FontName')

%these are the only allowed fonts in MatLab and so we have to weed them out
%and replace them:
mlabfontlist = {'AvantGarde','Helvetica-Narrow','Times-Roman','Bookman',...
    'NewCenturySchlbk','ZapfChancery','Courier','Palatino','ZapfDingbats',...
    'Helvetica', 'CMSY10', 'CMMI10'};%,'Symbol'};

for k = 1:length(mlabfontlist)
ff = strrep(ff,mlabfontlist{k},actualfont);
end

% now change the size of the bounding box
% define the bounding box size
boundingbox = [0, 0, ww*72,hh*72];
actualbox = ['%%BoundingBox: 0 0 ', num2str(boundingbox(3)), ' ', num2str(boundingbox(4)) ];
% now explicitly define the size of the bounding box
ff = strrep(ff, '%%BoundingBox: (atend)', actualbox);

% open the file up and overwrite it
fid = fopen(figfilestr,'w');
fprintf(fid,'%s',ff);
fclose(fid);






