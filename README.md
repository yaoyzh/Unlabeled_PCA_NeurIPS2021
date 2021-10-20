Code of the paper: 
Y. Yao, L. Peng, M. C. Tsakiris. Unlabeled principal component analysis. Neural Information Processing Systems (NeurIPS), 2021. 

1. To reproduce the figures in the paper, please first run the file "setup.m" and then run the five files: "figure1_RPCA.m", "figure2_dense.m", "figure3_sparse.m", "figure4_YaleB.m", and "figure5_deanonymization". 

2. To run the AIEM algorithm, one needs to compile "sympol3Mat.cpp" (r=3) and "sympol4Mat.cpp" (r=4) into MEX files. One also needs to install the Bertini solver and its MATLAB interface "BertiniLab" (r=5), see https://bertini.nd.edu/. 

3. To run the CCV-Min algorithm, one needs to compile "lapjv2.cpp" into a MEX file. 

4. To run 'L1_RR.m', it is required to install the CVX MATLAB toolbox.