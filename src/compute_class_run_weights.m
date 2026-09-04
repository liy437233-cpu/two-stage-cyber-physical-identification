function weights = compute_class_run_weights(y, run_id, beta_by_class, alpha)
%COMPUTE_CLASS_RUN_WEIGHTS Compute normalized class-run training weights.

labels = string(y(:));
runs = string(run_id(:));
if numel(labels) ~= numel(runs) || isempty(labels)
    error('PUBLIC_METHOD_CODE:WeightRows', ...
        'y and run_id must have the same nonzero number of rows.');
end
if isnumeric(run_id) && any(~isfinite(run_id(:)))
    error('PUBLIC_METHOD_CODE:RunIdentifier', ...
        'Every record must have a finite run identifier.');
end
if any(ismissing(labels)) || any(ismissing(runs)) || any(strlength(runs) == 0)
    error('PUBLIC_METHOD_CODE:RunIdentifier', ...
        'Every record must belong to a labelled class and a run.');
end
if ~isscalar(alpha) || ~isnumeric(alpha) || ~isfinite(alpha)
    error('PUBLIC_METHOD_CODE:WeightAlpha', 'alpha must be a finite scalar.');
end
if ~isstruct(beta_by_class) || ~isscalar(beta_by_class)
    error('PUBLIC_METHOD_CODE:WeightBeta', ...
        'beta_by_class must explicitly define a scalar structure.');
end

class_names = string(fieldnames(beta_by_class));
if isempty(class_names) || ~all(ismember(labels, class_names))
    error('PUBLIC_METHOD_CODE:WeightClasses', ...
        'beta_by_class must explicitly cover every observed class.');
end

weights = zeros(numel(labels), 1);
for c = 1:numel(class_names)
    class_name = class_names(c);
    beta = beta_by_class.(char(class_name));
    if ~isscalar(beta) || ~isnumeric(beta) || ~isfinite(beta) || beta <= 0
        error('PUBLIC_METHOD_CODE:WeightBeta', ...
            'Each class coefficient must be a finite positive scalar.');
    end

    in_class = labels == class_name;
    n_c = sum(in_class);
    class_runs = unique(runs(in_class), 'stable');
    R_c = numel(class_runs);
    M_c = n_c^(1 - alpha);
    for r = 1:R_c
        in_class_run = in_class & runs == class_runs(r);
        n_cr = sum(in_class_run);
        weights(in_class_run) = beta * M_c / (R_c * n_cr);
    end
end

if any(~isfinite(weights)) || any(weights <= 0)
    error('PUBLIC_METHOD_CODE:WeightValidity', ...
        'Class-run weights must be finite and positive.');
end
weights = weights ./ mean(weights);
if abs(mean(weights) - 1) > 1e-10
    error('PUBLIC_METHOD_CODE:WeightNormalization', ...
        'Class-run weights must be normalized to mean one.');
end
end
