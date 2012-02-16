function subject_dir = getSubjectDir(subject)
    subject_dir = joinpath(joinpath(joinpath(getuserdir(),'KINARM'),'data'),subject);
end