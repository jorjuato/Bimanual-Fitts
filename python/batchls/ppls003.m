conf=Config('/media/data/cTS_ncVF');
conf.parallelMode=0;
conf.compress_pc=0;
p=Participant.load(3,conf);
p.update_ls();
p.conf.save_path='/media/data/cTS_ncVF';
p.save();
exit