function rndString = random_string(n)
% generates a random string of lower case letters of length n

% string containing all allowable letters (in this case lower case only)
LetterStore = char(97:122); 
rndString = LetterStore(ceil(length(LetterStore).*rand(1,n)));
