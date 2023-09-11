pragma circom 2.0.0

include 'boolean.circom'


///check if matrix 'in' is a splitting matrix 
template checkSplittingMatri(x,n) {
    signal input beforesplit[n*n];
    signal input aftersplit[n*n]
    signal out;
    component boolean_check[n*n];
    for (var i = 0; i < n*n; i++) {
        boolean_check[i] = Boolean();
        boolean_check[i].in <== in[i];
    }
    for (var i = 0; i < x; i++) {
        for (var j = 0; j < n; j++) {
            out <== out || (beforesplit[i*j] && aftersplit[(n-x-i)*j]);
        }
    }
}


