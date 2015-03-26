
```
A = reshape([6,2,0,2,6,0,0,0,36],3,3);
[V,L] = eig(A);
AA = V*L*V';
```

```
A = matrix(c(6,2,0,2,6,0,0,0,36), nrow=3))
res = eigen(A, symmetric=T)
AA = res$vec %*% diag(res$val) %*% t(res$vec)
```

  * In the future we may port to python. This seems to be growing in popularity within the machine learning community.