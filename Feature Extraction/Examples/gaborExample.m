% Example : Show the Gabor Wavelet
% Author : Chai Zhi  
% e-mail : zh_chai@yahoo.cn

function gaborExample

close all;
clear all;
clc;

% Parameter Setting
rows = 128;  columns = 128;
Kmax = pi / 2;
f = sqrt( 2 );
Delt = 2 * pi;
Delt2 = Delt * Delt;

% Show the Gabor Wavelets
for scale = 0 : 4
    for orientations = 1 : 8
        GW = gaborWavelet ( rows, columns, Kmax, f, orientations, scale, Delt2 ); % Create the Gabor wavelets
        figure( 2 );
        subplot( 5, 8, scale * 8 + orientations ),imshow ( real( GW ) ,[]); % Show the real part of Gabor wavelets
    end
    figure ( 3 );
    subplot( 1, 5, scale + 1 ),imshow ( abs( GW ),[]); % Show the magnitude of Gabor wavelets
end