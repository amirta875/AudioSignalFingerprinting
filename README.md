## Audio signals identification
Audio signals identification algorithm based on spectral features fingerprinting, promximate peak pairs and hash values matching.
The pipeline of this educational independent project was adapted from the famous [SHAZAM algorithm](https://www.ee.columbia.edu/~dpwe/papers/Wang03-shazam.pdf).
## Introduction
The basic procedure of identifing a short clip of music using a database of songs is described as follow:
1. Construct a database of spectral based features for multiple full-length songs.
2. When a clip is to be identified, calculate the corresponding features of the clip.
3. Search the database for a match with the features of the clip.

The spectral features for each audio signal will be characterized by the location of local peaks of magnitude in a spectrogram using the Short-time Fourier transform (STFT). Where the frequencies and timing of the peaks are stored as features and 
should be fairly robust to many possible forms of distortion, such as magnitude and phase error in the frequency domain due to the recording process or additive noise.
A clip is matched to a song by considering all possible shifts in time and comparing of both their features. In order to mitigate the computational challenges of matching a large amount of features they simplified and preprocessed. 
Lastly Pairs of peaks that are close in both time and frequency are identified resulting in a table consiting of inital time (t1), edge time (t2), inital frequency (f1),  inital frequency (f2).

We then convert each peak pair to a hash value from the vector (f1; f2; t2 − t1) which will serve as an index for a hash table for later song matching. In that manner peak pairs with the same frequencies and
separation in time are considered a match. The timing t1 and the songid are stored in the hash table.

When a clip is to be identifies, the list of pairs of peaks is produced, just as it would have been for a song in the database. Then the hash table is searched for each pair in the clip. This will produce a list
of matches, each with different stored values of t1 and songid. Some of these matches will be accidental, either because the same peak pair occurred at another time or in another song, or because the hash table
had a collision. However, we expect the correct song match to have a consistent timing offset from the clip. That is, the difference between t1 for the song and t1 for the clip should be the same for all correct matches.
Finally The song with the most matches for a single timing offset is considered the best match.

## Pipeline procedure

1. Import data and preprocessing - read the song using 'mp3SongRead'.Average the two channels, subtract the mean, and downsample.
2. Extract spectral fingerprint - Compute the spectrogram of the song using 'spectralFingerprint'.
3. Find peaks proximal pairs - Find the local pairs of proximal peaks in the spectrogram by using the matlab function circshift.
4. Train database - Add the pairs into a hash table using 'size2pixel' and 'addHashTable'
5. Load HASHTABLE, SONGID and settings that were created by 'buildDatabase' in stpes 1-4. 
6. Prepare a clip of music for identification either by a recording, a random song segment or an extrenal audio file.
7. Extract the list of frequency pairs from the clip in the same manner done in steps 1-3 .
8. Recover matches from hash table - Look up matches in the hash table, calculate time offsets, and sort them by song using 'matchSegment'.
9. SIdentify the song with the most matches for a single consistent timing offset

Steps 1-4 are executed first in order to build a song data base using the script 'buildDatabase'.

Steps 5-9 can be then be executed using the script 'testProcess' in order to find a match between a clip to a song.

Take note that testing different values of spectral and time\frequency window parameters can be used in order to study the best combination resulting in the optimal time-frequency resolution for optimal identification.

## Future work and improvments
1. Testing a diffrent kernal then the STFT such the DWT for more robust results
2. Adding a threshold value using an adaptive filter for peak finding.
