function printjpeg(fignum, figname, flags)
% printjpeg(fignum, figname, flags)
%
% Rendered automatically set to -opengl
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
    flags = '-opengl -r150 -loose';
end

% get the correct width of the figure
posi = get( fignum, 'position');
ww = posi(3)./72; % width figure in inches
hh = posi(4)./72; % height of paper in inches
set(fignum, 'papersize', [ww, hh], 'paperposition', [0, 0, ww, hh], 'paperpositionmode', 'auto')

figfilestr = [figname '.jpg'];
eval(['print -djpeg -f' num2str(fignum) ' ' flags ' ' figname ';']);
