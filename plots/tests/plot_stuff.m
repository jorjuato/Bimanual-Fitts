function plot_stuff(xp)
    for p=1:xp.size;
    pp=xp(p);
        plot_time_series(pp(1).bimanual{1,1,1},['pp',num2str(p),'-s1-trDD']);
        plot_time_series(pp(1).bimanual{2,2,1},['pp',num2str(p),'-s1-trED']);
        plot_time_series(pp(1).bimanual{2,3,1},['pp',num2str(p),'-s1-trEE']);
        plot_time_series(pp(7).bimanual{1,1,1},['pp',num2str(p),'-s7-trDD']);
        plot_time_series(pp(7).bimanual{2,2,1},['pp',num2str(p),'-s7-trEM']);
        plot_time_series(pp(7).bimanual{2,3,1},['pp',num2str(p),'-s7-trEE']);
    end
end
