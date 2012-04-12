
script_path='/home/jorge/Dropbox/dev/Bimanual-Fitts';
addpath(genpath(script_path));

data_dir='/media/data/out';
plot_dir='/media/data/plot';

steps=dir2(data_dir);
freqs=dir2(joinpath(data_dir,steps(1).name));
conds=setprod(1:length(steps),1:length(freqs));

labsConf = findResource(); 
if matlabpool('size') == 0
    matlabpool(labsConf.ClusterSize); 
end

parfor i=1:length(conds)
    save_path=joinpath(joinpath(data_dir,steps(conds(i,1)).name),freqs(conds(i,2)).name);
    plot_path=joinpath(joinpath(plot_dir,steps(conds(i,1)).name),freqs(conds(i,2)).name)
    if ~exist(plot_path,'dir')
        mkdir(plot_path);    
    elseif length(dir2(plot_path))>0
        continue
    end
    for j=1:10
        pplot_path=joinpath(plot_path,sprintf('participant%03d',j))
        if ~exist(pplot_path,'dir')
            p=Participant.load(j,save_path);
            p.plot_vf(pplot_path);
            p.plot_va(pplot_path);
        end
    end
end
exit
