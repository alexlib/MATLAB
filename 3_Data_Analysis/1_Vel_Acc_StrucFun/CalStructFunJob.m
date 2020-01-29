function CalStructFunJob()
datapath = '/scratch/users/stan26@jhu.edu/SinglePhaseTracks/SmoothTrackswithVel/';
filename = dir([datapath 'Tracks*.mat']);
for i = 2 : length(filename)
    jobname = extractAfter(extractBefore(filename(i).name, '.mat'), 'Tracks_' );
    fileID = fopen([datapath 'Jobs/'  jobname '.sh'],'w');
    txt = [ '#!/bin/bash -l \n' ...
    '#SBATCH --job-name=' jobname '\n' ...
    '#SBATCH --time=72:00:00 \n' ... 
    '#SBATCH --nodes=1 \n' ...
    '#SBATCH --cpus-per-task=24 \n' ...
    '#SBATCH --partition=shared \n' ...
    '#SBATCH --mem=100000MB \n' ...
    '#SBATCH --mail-type=end \n' ...
    '#SBATCH --mail-user=stan26@jhu.edu\n' ...
    '\n' ...
    '#run your job \n' ...
    'module load matlab \n' ...
    'matlab -nodisplay > ' datapath 'Jobs/result_'  jobname '.txt << EOF\n' ...
    'cd ~/work/Code/LocalCode/MATLAB/Post_analysis/ \n' ...
    'savepath = ''' datapath ''';\n'...
    'datapath = ''' datapath filename(i).name ''';\n'...
    'redges_lin = 0.1:0.5:100;\n'...
    'redges_log = 10.^(-1:0.05:2) ;\n'...
    'framerate = 5000;\n'...
    'save_name = ''StructFunction/SF_' jobname ''';\n'...
    '[statistics_struct, statistics_corr] = CalStructFun(savepath, 5000, redges_lin, redges_log, save_name, datapath);\n' ...
    'EOF\n'];
    fprintf(fileID, txt);
    fclose(fileID);
    system(['sbatch ' datapath 'Jobs/' jobname  '.sh']);
end
end

