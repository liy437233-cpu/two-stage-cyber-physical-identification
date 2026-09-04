function validate_inputs(X, y, group_id, feature_domain)
%VALIDATE_INPUTS Validate dimensions labels groups and feature domains.

method = method_definition();
validateattributes(X, {'numeric'}, {'2d', 'real', 'finite', 'nonempty'});

sample_count = size(X, 1);
if size(X, 2) ~= method.total_feature_count
    error('PUBLIC_METHOD_CODE:FeatureCount', ...
        'X must contain %d candidate features.', method.total_feature_count);
end

labels = string(y(:));
groups = string(group_id(:));
domains = string(feature_domain(:));

if numel(labels) ~= sample_count || numel(groups) ~= sample_count
    error('PUBLIC_METHOD_CODE:SampleCount', ...
        'X, y, and group_id must have the same number of rows.');
end
if any(ismissing(labels)) || ~all(ismember(labels, method.five_states))
    error('PUBLIC_METHOD_CODE:Labels', 'y must use the five frozen state labels.');
end
if any(ismissing(groups)) || numel(unique(groups)) < 2
    error('PUBLIC_METHOD_CODE:Groups', ...
        'group_id must define at least two nonmissing groups.');
end
if numel(domains) ~= method.total_feature_count
    error('PUBLIC_METHOD_CODE:Domains', ...
        'feature_domain must contain one entry per candidate feature.');
end

required = ["NETWORK"; "PHYSICAL_DYNAMIC"; ...
    "CYBER_PHYSICAL_CONSISTENCY"; "NORMAL_BEHAVIOR_RESIDUAL"];
counts = [method.domain_counts.network; method.domain_counts.physical_dynamic; ...
    method.domain_counts.cyber_physical_consistency; ...
    method.domain_counts.normal_behavior_residual];
for i = 1:numel(required)
    if sum(domains == required(i)) ~= counts(i)
        error('PUBLIC_METHOD_CODE:DomainCounts', ...
            'feature_domain does not match the frozen feature-domain contract.');
    end
end
end
