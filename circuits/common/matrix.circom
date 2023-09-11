pragma circom 2.0.0;

/// Given private matrix A of shape mxn and private vector X of length n,
/// returns an output vector B of length m such that B = A \times X.
template matrixMultiplication(m, n) {
    signal input A[m*n];
    signal input X[n];
    signal output B[m];
    signal intermediate[m*n];
    for (var i = 0; i < m; i++) {
        var lc = 0;
        for (var j = 0; j < n; j++) {
            intermediate[i*n+j] <== A[i*n+j] * X[j];
            lc += intermediate[i*n+j];
        }
        B[i] <== lc;
    }
}

template matrixSplit(n){
    signal input beforeSplit[n];
    signal input x;
    signal output afterSplit[n];
    for (var i = 0; i < n - x; i++) {
        afterSplit[i] <== beforeSplit[x + i];
    }
    for (var i = 0; i < x; i++) {
        afterSplit[n - x + i] <== beforeSplit[i];
    }

}