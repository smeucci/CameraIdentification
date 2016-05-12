function [segments, ids] = normalizedCuts(weights, varargin)
%NORMALIZEDCUTS Summary of this function goes here
%   Detailed explanation goes here

    p = inputParser;
    p.KeepUnmatched = true;
    defaultExtract = false;
    addOptional(p, 'verbose', defaultExtract, @(x) islogical(x));
    parse(p, varargin{:});
    verbose = p.Results.verbose;

    id = 'root';
    I = 1:size(weights, 1);
    [segments, ids] = NcutPartition(I, weights, id, verbose);
    
end

