/*
 * Note:
 * sk_all = sk_A + sk_B + sk_C
 * pk = sk_all *g

 * create a open card:
 * r = 1
 * c = E_pk(m, 1) = (g, m+pk)

 * ElGamalEncrypt:
 * c0 = r * g + ic0
 * c1 = r * pk + ic1
 * ic0 = 0
 * ic1 = m
*/

pragma circom 2.0.0;

include "../common/babyjubjub.circom";
include "../common/elgamal.circom";
include "../common/matrix.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";

/// input m: card value, group element on inner curve
/// input pk: public key, pk = (sk_A + sk_B + sk_C) * g, group element on inner curve
/// output open card: (c0, c1)
template CreateAnOpenCard(base, numBits){
    signal input m[2];                  //card value, group element on inner curve
    signal input pk[2];                 //public key, pk = (sk_A + sk_B + sk_C) * g, group element on inner curve
    signal output c0[2];                //c0 = r*g, group element on inner curve
    signal output c1[2];                //c1 = m + r*pk, group element on inner curve

    // Base8 generator of Baby JubJub curve: https://github.com/iden3/circomlibjs/blob/main/src/babyjub.js#L18-L21
    var base[2] = [5299619240641551281634865583518297030282874472190772894086521144482721001553,
                   16950150798460657717958625567821834550301663161624707787222815936182638968203];

    signal output dummy_output;  // Circom requires at least 1 output signal.
    dummy_output <== pk[0] * pk[1];

    component elgamal = ElGamalEncrypt(numBits, base);
    elgamal.ic0[0] <== 0;
    elgamal.ic0[1] <== 0;
    elgamal.ic1[0] <== m[0];
    elgamal.ic1[1] <== m[1];
    elgamal.r <== 1;
    elgamal.pk[0] <== pk[0];
    elgamal.pk[1] <== pk[1];
    c0[0] <== elgamal.c0[0];
    c0[1] <== elgamal.c0[1];
    c1[0] <== elgamal.c1[0];
    c1[1] <== elgamal.c1[1];
}
