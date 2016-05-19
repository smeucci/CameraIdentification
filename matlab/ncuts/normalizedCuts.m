function [segments, ids] = normalizedCuts(weights, varargin)
%NORMALIZEDCUTS Summary of this function goes here
%   Detailed explanation goes here

    p = inputParser;
    p.KeepUnmatched = true;
    defaultExtract = false;
    defaultType = 'NC';
    defaultThreshold = 10^-4;
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
        fprintf('\n-Normalized Cuts using aggregation coefficients\n');
        segments = NcutPartitionAggregationCoefficient(I, weights, id, threshold, verbose);
    else
        fprintf('\n-Normalized Cuts using ncut value\n');
        segments = NcutPartition(I, weights, id, threshold, verbose);
    end
       
end

