function vmhplfp(varargin)
	Args = struct('SkipSort', 0);
	Args.flags = {'SkipSort'};

	Args = getOptArgs(varargin,Args);

	vh = vmhighpass('auto','SaveLevels',2,varargin{:});
	vl = vmlfp('auto','SaveLevels',2,varargin{:});

	if(~Args.SkipSort)
		display('Launching spike sorting ...')
		% check to see if we should sort this channel
		if(isempty(dir('skipsort.txt')))
			% get channel string
			[p1, chstr] = nptFileParts(pwd);
			% get array string
			[p2, arrstr] = nptFileParts(p1);
			% get session string
			[p3, sesstr] = nptFileParts(p2);
			% get day string
			[p4, daystr] = nptFileParts(p3);
	
			% make channel direcory on HPC, copy to HPC, cd to channel directory, and then run hmmsort
			display('Creating channel directory ...')
			syscmd = ['ssh eleys@atlas7 "cd ~/hpctmp/Data/' daystr '/' sesstr '/' arrstr '; mkdir ' chstr '"'];
			display(syscmd)
			system(syscmd);
			display('Transferring rplhighpass file ...')
			syscmd = ['scp rplhighpass.mat eleys@atlas7:~/hpctmp/Data/' daystr '/' sesstr '/' arrstr '/' chstr];
			display(syscmd)
			rval=1;
			while(rval~=0)
				rval=system(syscmd);
			end
			display('Running spike sorting ...')
			syscmd = ['ssh eleys@atlas7 "cd ~/hpctmp/Data/' daystr '/' sesstr '/' arrstr '/' chstr '; ~/hmmsort/hmmsort_pbs.py ~/hmmsort"'];
			display(syscmd)
			system(syscmd);
		end  % if(isempty(dir('skipsort.txt')))
	end  % if(Args.SkipSort)
	