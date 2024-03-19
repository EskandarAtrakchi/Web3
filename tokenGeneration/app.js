let key;
let iv;

async function generateKey() {
    key = await window.crypto.subtle.generateKey(
        { name: "AES-CBC", length: 128 },
        true,
        ["encrypt", "decrypt"]
    );
}

async function encryptString(str) {
    const encodedString = new TextEncoder().encode(str);
    iv = window.crypto.getRandomValues(new Uint8Array(16));
    const encryptedData = await window.crypto.subtle.encrypt(
        { name: "AES-CBC", iv: iv },
        key,
        encodedString
    );
    return Array.prototype.map.call(new Uint8Array(encryptedData), x => ('00' + x.toString(16)).slice(-2)).join('');
}

async function decryptString(encryptedData) {
    const decryptedData = await window.crypto.subtle.decrypt(
        { name: "AES-CBC", iv: iv },
        key,
        encryptedData
    );
    return new TextDecoder().decode(decryptedData);
}

async function encrypt() {
    await generateKey();
    const input = document.getElementById('input').value;
    const encryptedHex = await encryptString(input);
    document.getElementById('output').innerText = "Encrypted: " + encryptedHex;
}

async function decrypt() {
    const input = document.getElementById('input').value;
    const encryptedData = new Uint8Array(input.match(/.{1,2}/g).map(byte => parseInt(byte, 16)));
    const decryptedString = await decryptString(encryptedData);
    document.getElementById('output').innerText = "Decrypted: " + decryptedString;
}