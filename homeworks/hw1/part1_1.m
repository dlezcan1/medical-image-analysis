%% part1_1.m
% 
% this is a script to run an analysis on part 1 - 1d 
%
% - written by: Dimitri Lezcano

%% (d)
vol = analyze75read('ICBM_Template-1c.hdr');

% histogram
[counts,bin_edges] = histcounts(vol(:),100);
bin_mids = bin_edges(1:end-1) + (bin_edges(2) - bin_edges(1))*0.5;
fig = figure(1); bar(bin_mids,log(counts))
saveas(fig, 'ICBM_Template-1d.png');

mean_vol = mean(vol(:))
var_vol = var(double(vol(:)))

fid = fopen('ICBM_Template-1d.txt', 'w');
fprintf(fid, "mean: %f\nvar: %f", mean_vol, var_vol);
fclose(fid);