function test_stuff()
conf=Config();
conf.inmemory=1;
xp=Experiment(conf);
tr=xp(5).sessions(1).bimanual{1,2,3};
i=500:(length(tr.ts.Lx)-500);
figure; subplot(2,1,1); plot(tr.ts.Romega(i),'b');hold on; plot(tr.ts.Lomega(i),'r'); subplot(2,1,2);plot(tr.ts.Romega(i)./tr.ts.Lomega(i),'.')
figure; subplot(2,3,[1,2]); plot(tr.ts.Romega(i),'b');hold on; plot(tr.ts.Lomega(i),'r'); subplot(2,3,[4,5]);plot(tr.ts.Romega(i)./tr.ts.Lomega(i),'.'); subplot(2,3,[3,6]);hist(tr.ts.Romega(i)./tr.ts.Lomega(i),30)
figure; scatter(diff(tr.ts.Romega),diff(tr.ts.Lomega))
figure; scatter(filterdata(diff(filterdata(tr.ts.Romega,8)),8),filterdata(diff(filterdata(tr.ts.Lomega,8)),8))
figure; plot(filterdata(diff(filterdata(tr.ts.Romega,8)),8)./filterdata(diff(filterdata(tr.ts.Lomega,8)),8))
figure; hist(filterdata(diff(filterdata(tr.ts.Romega,8)),8)./filterdata(diff(filterdata(tr.ts.Lomega,8)),8))
La=filterdata(diff(filterdata(tr.ts.Lomega,8)));
Ra=filterdata(diff(filterdata(tr.ts.Romega,8)));
scatter(La,Ra)
figure;[n xout]=hist(Ra,100); bar(xout,n,'r');hold on; [n xout]=hist(La,100); bar(xout,n,'b');