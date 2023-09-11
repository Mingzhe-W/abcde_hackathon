/*
 * Note:
 * sk_all = sk_A + sk_B + sk_C
 * pk = sk_all *g

 * Mask ElGamal:
 * c = E_pk(m, r) = (r*g, m + r*pk) = (initc0, initc1)
 * when init a open card, r = 1, so c = E_pk(m, 1) = (g, m+pk)

 * remask ElGamel:
 * Init: (initc0, initc1)
 * Alice Encrypt: r = a
 * (c0[1], c1[1]) = (a*g + initc0, m + a*pk + initc1) = ((a+1)*g, m+(a+1)*pk)
 * Bob Encrypt: r = b
 * (c0[2], c1[2]) = (b*g + c0[1], m + b*pk + c1[1]) = ((a+b+1)*g, m+(a+b+1)*pk)
 * Charlie Encrypt: r = c
 * (c0[3], c1[3]) = (c*g + c0[2], m + c*pk + c1[2]) = ((a+b+c+1)*g, m+(a+b+c+1)*pk)

 * Bob Decrypt:
 * m+(a+b+c+1)*pk - sk_B*(a+b+c+1)*g
 * ...
*/

pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/bitify.circom";
include "../../node_modules/circomlib/circuits/escalarmulfix.circom";
include "../../node_modules/circomlib/circuits/escalarmulany.circom";
include "../../node_modules/circomlib/circuits/babyjub.circom";

// ElGamalEncrypt:
// c0 = r * g + ic0
// c1 = r * pk + ic1
template ElGamalEncrypt(numBits, base) {
    signal input ic0[2];  // a group element on inner curve
    signal input ic1[2];  // a group element on inner curve
    signal input r;       // trapdoor of the encryption, {0,1}^numBits
    signal input pk[2];   // aggregate PK, which is a group element on inner curve
    signal output c0[2];  // a group element on inner curve
    signal output c1[2];  // a group element on inner curve
    // c0 = r * g + ic0
    component bitDecomposition = Num2Bits(numBits);
    bitDecomposition.in <== r;
    component computeC0 = EscalarMulFix(numBits, base);
    for(var i=0; i<numBits; i++) {
        computeC0.e[i] <== bitDecomposition.out[i];
    }
    component adder0 = BabyAdd();
    adder0.x1 <== computeC0.out[0];
    adder0.y1 <== computeC0.out[1];
    adder0.x2 <== ic0[0];
    adder0.y2 <== ic0[1];
    c0[0] <== adder0.xout;
    c0[1] <== adder0.yout;

    // c1 = r * pk + ic1
    component computeC1 = EscalarMulAny(numBits);
    computeC1.p[0] <== pk[0];
    computeC1.p[1] <== pk[1];
    for(var i=0; i<numBits; i++) {
        computeC1.e[i] <== bitDecomposition.out[i];
    }
    component adder1 = BabyAdd();
    adder1.x1 <== computeC1.out[0];
    adder1.y1 <== computeC1.out[1];
    adder1.x2 <== ic1[0];
    adder1.y2 <== ic1[1];
    c1[0] <== adder1.xout;
    c1[1] <== adder1.yout;
}

// ElGamalDecrypt:
// c1 - sk * c0
// this works recursively since: 
// c1 - sk * c0 = (r * pk) + ic1 - sk * (r * g + ic0) = ic1 - sk * ic0
template ElGamalDecrypt(numBits) {
    signal input c0[2];  // c0 of ElGamalEncrypt
    signal input c1[2];  // c1 of ElGamalEncrypt
    signal input sk;     // secret key, {0, 1}^numBits
    signal output m[2];  // decrypt result
    component bitDecomposition = Num2Bits(numBits);
    bitDecomposition.in <== sk;
    component scalarMul = EscalarMulAny(numBits);
    scalarMul.p[0] <== c0[0];
    scalarMul.p[1] <== c0[1];
    for(var i=0; i<numBits; i++) {
        scalarMul.e[i] <== bitDecomposition.out[i];
    }
    component adder = BabyAdd();
    adder.x1 <== 0 - scalarMul.out[0];
    adder.y1 <== scalarMul.out[1];
    adder.x2 <== c1[0];
    adder.y2 <== c1[1];
    m[0] <== adder.xout;
    m[1] <== adder.yout;
}
