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
        4729216732869195612434498531093479787355192462860783833825718386781843061432n,
        23505487361740545173683782069533796960789246504489736767087178047491174948n
    ]
    const bid = 40;
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