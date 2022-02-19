# ROBO_EDGE

### Citation

[1] S. Wang, Y.-C. Wu, M. Xia, R. Wang, and H. V. Poor, ``Machine intelligence at the edge with learning centric power allocation,'' IEEE Transactions on Wireless Communications, vol. 19, no. 11, Jul. 2020. 

[2] L. Zhou, Y. Hong, S. Wang*, R. Han, D. Li, R. Wang, and Q. Hao, ``Learning centric wireless resource allocation for edge computing: Algorithm and experiment,'' IEEE Transactions on Vehicular Technology, vol. 70, no, 1, pp. 1035-1040, Jan. 2021.

### Dependency

- Enabled Wireless NIC * 1
- numpy
- tensoflow
- sklearn

### How to Use

Server side: `make run-collect alg=svm` or `make run-collect alg=cnn`

Client side:  `make run-feeder alg=svm` or `make run-feeder alg=cnn`
