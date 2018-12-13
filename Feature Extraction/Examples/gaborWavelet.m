function GW = gaborWavelet (rows, columns, Kmax, f, orientations, scale, Delt2);
% Create the Gabor Wavelet Filter
% Author : Chai Zhi  
% e-mail : zh_chai@yahoo.cn

k = ( Kmax / ( f ^ scale ) ) * exp( i * orientations * pi / 8 );% Wave Vector

kn2 = ( abs( k ) ) ^ 2;

GW = zeros ( rows , columns );

for m = -rows/2 + 1 : rows/2
    
    for n = -columns/2 + 1 : columns/2
        
        GW(m+rows/2,n+columns/2) = ( kn2 / Delt2 ) * exp( -0.5 * kn2 * ( m ^ 2 + n ^ 2 ) / Delt2) * ( exp( i * ( real( k ) * m + imag ( k ) * n ) ) - exp ( -0.5 * Delt2 ) );
    
    end

end