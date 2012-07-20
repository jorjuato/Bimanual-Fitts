function posterplot(filename1,filename2)
if nargin<2,filename2='/home/jorge/Dropbox/ewep12/def.mat';end
if nargin==0,filename1='/home/jorge/Dropbox/ewep12/Anal_Anovas.mat';end

load(filename1);
v=load(filename2);
avs=obj;

%MOVEMENT TIME RELATED PLOTS
%Fetch data
MTR  = fetch_from_ANOVA(avs.Anova_MTR);
MTL  = fetch_from_ANOVA(avs.Anova_MTL);
MTRu = fetch_from_ANOVA(avs.Anova_UMTR);
MTLu = fetch_from_ANOVA(avs.Anova_UMTL);

%posterplot_LearningMT(MTR,MTL,MTRu,MTLu);
%posterplot_OverallMT(MTR,MTL,MTRu,MTLu);

%SYNCHRONICITY RELATED PLOTS
phDMean = fetch_from_ANOVA(avs.Anova_phDiffMean);
phDSTD  = fetch_from_ANOVA(avs.Anova_MTR);
phDMI   = fetch_from_ANOVA(avs.Anova_MI);
FR      = fetch_from_ANOVA(avs.Anova_Rf);
FL      = fetch_from_ANOVA(avs.Anova_Lf);
FLS     = fetch_from_ANOVA(avs.Anova_flsPC);
rho     = fetch_from_ANOVA(avs.Anova_rho);

posterplot_LearningPhase(phDMean,phDSTD,phDMI);
%posterplot_LearningFrequency(FR,FL,v.FRu,v.FLu);
%posterplot_LearningLocking(rho,FLS);
%HARMONICITY  RELATED PLOTS
%posterplot_LearningHarmonicity(v.HR,v.HL,v.HRu,v.HLu);

end