clear;clc;
N=100;
x = (100-0)*rand(N,1);
y = (100-0)*rand(N,1);
tiledlayout(2,1)

nexttile
plot(x,y,".");
title("origin")

xsort = sort(x);
ysort = sort(y);
hold off;
nexttile
plot(xsort,ysort,".");
title("sort")

