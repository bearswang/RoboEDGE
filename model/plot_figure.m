clear all;

load('dl.mat');
semilogx(xin,1-yout,'square');
hold on;
semilogx(xin_s,1-yout_s,'-k');

xnew =[500, 1000, 5000, 10000];
ynew =[
0.9240000247955322
0.9490000009536743
0.9700000286102295
0.9810000061988831
]
semilogx(xnew,1-ynew,'square');


load('svm.mat');
semilogx(xin,1-yout,'o');
semilogx(xin_s,1-yout_s,'-k');

xnew =[300 400 500 1000]; % in bit
ynew =[
0.9522613065326633
0.957286432160804
0.9585427135678392
0.9660804020100503
];
semilogx(xnew,1-ynew,'o');