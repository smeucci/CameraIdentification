function segments = normalizedCuts(weights, varargin)
% Normalized Cuts algorithm.
%
%   INPUTS
%   Required parameters
%
%   weights  : matrix of weights for the grapth
%   
%   Optional parameters (key, value)
%   
%   'Verbose'  : true/false if information about clustering should be
%                printed (default false)
%   'Type'     : which threshold value consider to stop recursion.
%                Possible value are 'NC' for ncut value and 'AC' for
%                aggregation coefficient. (default 'NC')
%   'Threshold': precomputed treshold value. Default 10^-5 for NC. Not
%                an optional parameters for type 'AC' (range [0, 1])
%
%   USAGE  output = normalizedCuts(weights, 'Type', 'AC', 'Threshold',
%                   0.9966, 'Verbose', true);
%
%   OUTPUT
%
%   segments : a cell array of vectors contains ids, represents the clusters   
%
% ----------------------------------------------------
% Authors: Lorenzo Cioni, Saverio Meucci
% ----------------------------------------------------

    p = inputParser;
    p.KeepUnmatched = true;
    defaultExtract = false;
    defaultType = 'NC';
    defaultThreshold = 10^-5;
    addOptional(p, 'Verbose', defaultExtract, @(x) islogical(x));
    addOptional(p, 'Type', defaultType, @(x) ischar(x));
    addOptional(p, 'Threshold', defaultThreshold, @(x) isnumeric(x));
    parse(p, varargin{:});
    verbose = p.Results.Verbose;
    type = p.Results.Type;
    threshold = p.Results.Threshold;

    id = 'root';
    I = 1:size(weights, 1);
    if strcmp(type, 'AC')
        if verbose
            fprintf('\n- Normalized Cuts using aggregation coefficients\n\n');
        end
        
        max_value = max(max(weights));
        min_value = min(min(weights));
        weights = remap(weights, [min_value, max_value], [0, 1]);
        segments = NcutPartitionAggregationCoefficient(I, weights, id, threshold, verbose);
    else
        if verbose
            fprintf('\n- Normalized Cuts using ncut value\n\n');
        end
        segments = NcutPartition(I, weights, id, threshold, verbose);
    end
       
end

