# IrisRecognition

As part of my undergraduate studies at university I developed a system for automated iris recognition, through both verification and identification, in MATLAB. The included report details implementations of several approaches for each stage of the recognition system - two methods for iris localisation, one for normalisation, and four for feature extraction and matching:

- Phase based encoding with 2D Gabor wavelets
- Local intensity encoding through cumulative-sum analysis
- Detail-decomposition based encoding with Haar wavelets
- Gradient based encoding through local gradient histograms

The implemented extraction and matching approaches were compared, looking at their speed, accuracy, false accept and reject rates, ease of implementation and efficiency, when matching images from the CASIA iris database. Implementation issues, localisation, encoding and matching results were discussed, and an iris recognition system that links the most successful approaches from each stage through the graphical user interface was built with an identification accuracy of 95.74%.
