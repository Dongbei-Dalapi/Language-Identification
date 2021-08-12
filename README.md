# Language-Identification
A Language identifier using n-grams

## N-Gram-Based Text Categorization
The method is from Cavnar and Trenkle 2001. They found that in languages, a small number of n-grams pop up all over the place. Thus, only a tiny number of n-grams are useful pointers. Documents from a language should have similar n-gram frequency distributions. They create a profile of a language using a small amount of text in the following manner:
- Count each 1...5-gram in the text (discard all characters that are not letters or quotes)
- Sort the n-grams by frequency (most frequent first)
- Retain the 300 most frequent n-grams
After creating profiles of the documents, compare the profile of the document with the profile of each language and choose the language with the most similar profile.
The distance function is defined:
𝑑(𝐴,𝐵)=Σ𝑛𝑔𝑟𝑎𝑚∈𝐴|𝑟𝑎𝑛𝑘(𝑛𝑔𝑟𝑎𝑚,𝐴)−𝑟𝑎𝑛𝑘(𝑛𝑔𝑟𝑎𝑚,𝐵)|
 
, given the document profile A and the language profile B. The rank function gives the rank of the n-gram in the profile. If the profile doesn't have the n-gram, it gives the size of the profile.

## Data
The file training.tsv contains the initial parts of the translations of the Universal Declaration of Human Rights into 190 languages. Each line of the file consists of

- the name of the language,
- followed by a tabulator,
- followed by the corpus for that language, represented as a sequence of words separated by spaces.

### Create Profile - counting n-grams
The subroutine countNGramsRanks in Profile.pm counts all the minNGramLength..maxNGramLength-grams in the text. So, if minNGramLength = 1 and maxNGramLength = 5, then all 1..5-grams in the text are counted. The hash that is returned should contain the rank of the 300 most frequent n-gram in the text.

### Identify the language
With the n-gram counting implemented, the Profile class can be used to create profiles and to compute the distance between two profiles (see Profile distance). The most crucial method "identify" should do the following:
- Create a profile for the text given as an argument to identify.
- Compute the distance between the text's profile and each language profile.
- Return the language with the smallest distance from the text profile.

### Evaluation
run Language_Guesser.pl 
```
perl Language_Guesser.pl 
```

