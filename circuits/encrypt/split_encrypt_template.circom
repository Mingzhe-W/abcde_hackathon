pragma circom 2.0.0;

include "../common/elgamal.circom";
include "../common/matrix.circom";
include "../common/splitting.circom";
include "../common/babyjubjub.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";

/// X layout:
/// [ic_{0,0}.x, ic_{1,0}.x, ..., ic_{n-1,0}.x,
///  ic_{0,0}.y, ic_{1,0}.y, ..., ic_{n-1,0}.y,
///  ic_{0,1}.x, ic_{1,1}.x, ..., ic_{n-1,1}.x,
///  ic_{0,1}.y, ic_{1,1}.y, ..., ic_{n-1,1}.y,
/// ]
/// Here, the i^th cards is represented as two group elements on inner curve
///  ic_{i,0}.x, ic_{i,0}.y, ic_{i,1}.x, ic_{i,1}.y
template SplitEcryptTemplate(base, numCards, numBits){
    signal input x;                     // the splitting point
    signal input X[4*numCards];         // before splitting matrix,  group elements on inner curve
    signal input R[numCards];           // numCards scalars as randomness
    signal input pk[2];                 // aggregate PK, which is a group element on inner curve
    signal output Y[4*numCards];        // after splitting and mask matrix. Y shares the same layout as X.
    signal B[4*numCards];               // only after splitting matrix, group elements on inner curve
    component splitting = Splitting(x, numCards);
    for (var i = 0; i < numCards*numCards; i++) {
        splitting.beforesplit[i] <== beforesplit[i];
    }
    for (var i = 0; i < numCards*numCards; i++) {
        splitting.aftersplit[i] <== afterSplit[i];
    }
    component split[4];
    for (var i = 0; i < 4; i++) {
        split[i] = matrixSplit(x, numCards);
        for (var j = 0; j < numCards; j++) {
            split[i].beforeSplit[j] <== X[i*numCards + j];
        }
        for (var j = 0; j < numCards; j++) {
            B[i*numCards + j] <== split[i].afterSplit[j];
        }
    }
    component elgamal[numCards];
    for (var i = 0; i < numCards; i++) {
        elgamal[i] = ElGamalEncrypt(numBits, base);
        elgamal[i].ic0[0] <== B[i];
        elgamal[i].ic0[1] <== B[numCards + i];
        elgamal[i].ic1[0] <== B[2*numCards + i];
        elgamal[i].ic1[1] <== B[3*numCards + i];
        elgamal[i].r <== R[i];
        elgamal[i].pk[0] <== pk[0];
        elgamal[i].pk[1] <== pk[1];
        Y[i] <== elgamal[i].c0[0];
        Y[numCards + i] <== elgamal[i].c0[1];
        Y[2*numCards + i] <== elgamal[i].c1[0];
        Y[3*numCards + i] <== elgamal[i].c1[1];
    }

}