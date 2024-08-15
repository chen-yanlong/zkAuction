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
        3969447157557932097774244667757157969615360788958242948945934100470100738412n,
        3143472736932725503009342154175562165289360949082855923271475181291282944325n
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





