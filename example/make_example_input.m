function example = make_example_input()
%MAKE_EXAMPLE_INPUT Build a compact numeric matrix for software-path validation.

method = method_definition();
rng(17, 'twister');

group_count = 4;
runs_per_state_per_group = 2;
rows_per_run = 3;
sample_count = group_count * runs_per_state_per_group * rows_per_run * ...
    numel(method.five_states);

X = randn(sample_count, method.total_feature_count);
labels = strings(sample_count, 1);
group_id = zeros(sample_count, 1);
run_id = zeros(sample_count, 1);
row = 0;
run = 0;
for g = 1:group_count
    for c = 1:numel(method.five_states)
        for r = 1:runs_per_state_per_group
            rows = row + (1:rows_per_run);
            labels(rows) = method.five_states(c);
            group_id(rows) = g;
            run = run + 1;
            run_id(rows) = run;
            row = row + rows_per_run;
        end
    end
end

feature_domain = [ ...
    repmat("NETWORK", method.domain_counts.network, 1); ...
    repmat("PHYSICAL_DYNAMIC", method.domain_counts.physical_dynamic, 1); ...
    repmat("CYBER_PHYSICAL_CONSISTENCY", ...
        method.domain_counts.cyber_physical_consistency, 1); ...
    repmat("NORMAL_BEHAVIOR_RESIDUAL", ...
        method.domain_counts.normal_behavior_residual, 1)];
feature_name = "F" + compose('%03d', (1:method.total_feature_count)');

selected_first = [1:45, 102:120, 46:77, 194:225];
ranking_order = [selected_first, ...
    setdiff(1:method.total_feature_count, selected_first, 'stable')].';

example = struct( ...
    'X', X, ...
    'y', categorical(labels, method.five_states, method.five_states), ...
    'group_id', group_id, ...
    'run_id', run_id, ...
    'feature_domain', feature_domain, ...
    'feature_name', feature_name, ...
    'ranking_order', ranking_order);
end
