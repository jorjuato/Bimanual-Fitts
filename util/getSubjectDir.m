function subject_dir = getSubjectDir(subject,root_path)
    if nargin<2, root_path=joinpath(joinpath(getuserdir(),'KINARM'),'data'); end
    
    subject_dir = joinpath(root_path,subject);
end
