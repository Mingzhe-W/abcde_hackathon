/*
 * Note:
 * sk_all = sk_A + sk_B + sk_C
 * pk = sk_all *g

 * Mask ElGamal:
 * c = E_pk(m, r) = (r*g, m + r*pk) = (initc0, initc1)
 * when init a open card, r = 1, so c = E_pk(m, 1) = (g, m+pk)

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
include "../node_modules/circomlib/circuits/bitify.circom";

template MaskAnOpenCard(numBits){

    signal input ic0[2];                // c0, a card waited to be masked, group element on inner curve
    signal input ic1[2];                // c1, a card waited to be masked, group element on inner curve
    signal input r;                     // random number, field element
    signal input pk[2];                 //public key, pk = (sk_A + sk_B + sk_C) * g, group element on inner curve
    signal output c0[2];                //c0 = r*g, group element on inner curve
    signal output c1[2];                //c1 = m + r*pk, group element on inner curve

    // Base8 generator of Baby JubJub curve: https://github.com/iden3/circomlibjs/blob/main/src/babyjub.js#L18-L21
    var base[2] = [5299619240641551281634865583518297030282874472190772894086521144482721001553,
                   16950150798460657717958625567821834550301663161624707787222815936182638968203];

    signal output dummy_output;  // Circom requires at least 1 output signal.
    dummy_output <== pk[0] * pk[1];

    component elgamal = ElGamalEncrypt(numBits, base);
    elgamal.ic0[0] <== ic0[0];
    elgamal.ic0[1] <== ic0[1];
    elgamal.ic1[0] <== ic1[0];
    elgamal.ic1[1] <== ic1[1];
    elgamal.r <== r;
    elgamal.pk[0] <== pk[0];
    elgamal.pk[1] <== pk[1];
    c0[0] <== elgamal.c0[0];
    c0[1] <== elgamal.c0[1];
    c1[0] <== elgamal.c1[0];
    c1[1] <== elgamal.c1[1];
}
component main {public [pk, ic0, ic1, r]}  = MaskAnOpenCard(254);
