
[Haar4ShiftAlist1_200, Haar4ShiftIlist1_200, Haar4ShiftResults1_200] = testHaar(EYES4, HaarBins, 1, 200);

[Haar4ShiftAlist201_400, Haar4ShiftIlist201_400, Haar4ShiftResults201_400] = testHaar(EYES4, HaarBins, 201, 400);

[Haar4ShiftAlist401_600, Haar4ShiftIlist401_600, Haar4ShiftResults401_600] = testHaar(EYES4, HaarBins, 401, 600);

[Haar4ShiftAlist601_800, Haar4ShiftIlist601_800, Haar4ShiftResults601_800] = testHaar(EYES4, HaarBins, 601, 800);

[Haar4ShiftAlist801_1034, Haar4ShiftIlist801_1034, Haar4ShiftResults801_1034] = testHaar(EYES4, HaarBins, 801, 1034);

Haar4ShiftResults = combine(Haar4ShiftResults1_200, Haar4ShiftResults201_400, ...
    Haar4ShiftResults401_600, Haar4ShiftResults601_800, Haar4ShiftResults801_1034);

Haar4ShiftAList = [Haar4ShiftAlist1_200, Haar4ShiftAlist201_400, Haar4ShiftAlist401_600, Haar4ShiftAlist601_800, Haar4ShiftAlist801_1034];

Haar4ShiftIList = [Haar4ShiftIlist1_200, Haar4ShiftIlist201_400, Haar4ShiftIlist401_600, Haar4ShiftIlist601_800, Haar4ShiftIlist801_1034];