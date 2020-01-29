function t = JobTimer(jobname)
t = timer;
t.StartFcn = @(~,~)disp('A timer is started!');
t.TimerFcn = @(~,~)system(['sbatch ' jobname]);% resubmit the job if not done
t.stopFcn = @(~,~)disp('A timer is stopped!');
t.StartDelay = 60 * 60 * 2 - 600;
t.ExecutionMode = 'singleShot';
start(t);
end
