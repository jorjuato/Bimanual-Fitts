function plot_trial_harmonicity(tr)
figure;
subplot(2,2,1)
hist(tr.ts.LHarmonicityUp);
subplot(2,2,2)
hist(tr.ts.RHarmonicityUp);
subplot(2,2,3)
hist(tr.ts.LHarmonicityDown);
subplot(2,2,4)
hist(tr.ts.RHarmonicityDown);