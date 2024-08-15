// for user
const { poseidonEncrypt } = require("poseidon-encryption")
const encrypt = (pubKey, message) => {

    const nonce = 0
    const ciphertext = poseidonEncrypt(message, pubKey, nonce)

    console.log(ciphertext);
    return ciphertext;
}

const main = () => {
    const pubKey = [
        8197276928207956703265299574184843680513875332985099562468899630985177266774n,
        123696325084722853043213430085078235709184893374861677866066449460790092511n
    ]
    const bid = 100;
    const ciphertext = encrypt(pubKey, [bid])
    const ciphertextString = ciphertext.map(num => num.toString());
    
}


// const two128 = F.e('340282366920938463463374607431768211456')

// const genRandomNonce = ()=> {

//     const max = two128
//     // Prevent modulo bias
//     const lim = F.e('0x10000000000000000000000000000000000000000000000000000000000000000')
//     const min = F.mod(F.sub(lim, max), max)

//     let rand
//     while (true) {
//         rand = BigInt('0x' + crypto.randomBytes(32).toString('hex'))

//         if (rand >= min) {
//             break
//         }
//     }

//     const privKey = F.mod(F.e(rand), max)
//     assert(privKey < max)

//     return privKey
// }

main();