const crypto = require('crypto');

// Secret passphrase 
const secretKey = 'YourSecretKeyHere';

// Function to generate a token from the seed phrase
function generateToken(seedPhrase) {
    const cipher = crypto.createCipher('aes-256-cbc', secretKey);
    let encrypted = cipher.update(seedPhrase, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    return encrypted;
}

// Function to retrieve the seed phrase from the token
function retrieveSeedPhrase(token) {
    const decipher = crypto.createDecipher('aes-256-cbc', secretKey);
    let decrypted = decipher.update(token, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    return decrypted;
}

// tokedn generating 
const seedPhrase = "this is a test";
const token = generateToken(seedPhrase);
console.log("Generated token:", token);

// retrieving the seedphrase 
const retrievedSeedPhrase = retrieveSeedPhrase(token);
console.log("Retrieved seed phrase:", retrievedSeedPhrase);
