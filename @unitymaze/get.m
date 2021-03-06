function [r,varargout] = get(obj,varargin)
%dirfiles/get Get function for dirfiles objects
%dirfiles/GET Returns object properties
%   VALUE = GET(OBJ,PROP_NAME) returns an object 
%   property.
%   In dirfiles, PROP_NAME can be one of the following:
%      'ObjectLevel'
%	 'AnalysisLevel'
%
%   Dependencies: 

Args = struct('ObjectLevel',0, 'AnalysisLevel',0, 'GroupPlotProperties',0, ...
				'Number',0, 'Trial',0);
Args.flags ={'ObjectLevel','AnalysisLevel','GroupPlotProperties','Number','Trial'};
Args = getOptArgs(varargin,Args);

% set variables to default
r = [];

if(Args.ObjectLevel)
	% specifies that the object should be created in the session directory
	r = 'Session';
elseif(Args.AnalysisLevel)
	% specifies that the AnalysisLevel of the object is 'AllIntragroup'
	r = 'Single';
elseif(Args.GroupPlotProperties)
	r = 'Vertical';
elseif(Args.Number && Args.Trial)
	r = obj.data.setIndex(end);
else
	% if we don't recognize and of the options, pass the call to parent
	% in case it is to get number of events, which has to go all the way
	% nptdata/get
	r = get(obj.nptdata,varargin{:});
end