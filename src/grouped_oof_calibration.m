function [calibrator, oof_scores] = grouped_oof_calibration( ...
    X, y, group_id, run_id, class_names, beta_by_class, alpha)
%GROUPED_OOF_CALIBRATION Fit one-vs-rest logistic calibrators from group-held-out scores.

method = method_definition();
labels = string(y(:));
groups = string(group_id(:));
class_names = string(class_names(:));

if size(X, 1) ~= numel(labels) || numel(labels) ~= numel(groups) || ...
        numel(labels) ~= numel(run_id)
    error('PUBLIC_METHOD_CODE:CalibrationRows', ...
        'X, y, group_id, and run_id must have the same number of rows.');
end
if ~all(ismember(labels, class_names)) || numel(unique(groups)) < 2
    error('PUBLIC_METHOD_CODE:CalibrationInputs', ...
        'Calibration labels and groups do not satisfy the grouped OOF contract.');
end
if any(ismissing(groups)) || any(strlength(groups) == 0)
    error('PUBLIC_METHOD_CODE:CalibrationGroups', ...
        'Every record must belong to a valid held-out group.');
end

oof_scores = nan(size(X, 1), numel(class_names));
held_out_groups = unique(groups, 'stable');
for g = 1:numel(held_out_groups)
    held_out = groups == held_out_groups(g);
    training = ~held_out;
    if ~all(ismember(class_names, unique(labels(training))))
        error('PUBLIC_METHOD_CODE:CalibrationCoverage', ...
            'Every group-held-out training partition must retain every class.');
    end

    learner = templateTree( ...
        'MinLeafSize', method.bagged_tree.min_leaf_size, ...
        'NumVariablesToSample', method.bagged_tree.num_predictors_to_sample);
    fold_weights = compute_class_run_weights( ...
        labels(training), run_id(training), beta_by_class, alpha);
    classifier = fitcensemble(X(training, :), ...
        categorical(labels(training), class_names, class_names), ...
        'Method', 'Bag', ...
        'NumLearningCycles', method.bagged_tree.num_learners, ...
        'Learners', learner, ...
        'Weights', fold_weights, ...
        'ClassNames', categorical(class_names, class_names, class_names));
    [~, raw_scores] = predict(classifier, X(held_out, :));
    oof_scores(held_out, :) = align_scores( ...
        raw_scores, string(classifier.ClassNames), class_names);
end

if any(~isfinite(oof_scores), 'all')
    error('PUBLIC_METHOD_CODE:OOFCompleteness', ...
        'Every row must receive exactly one group-held-out score vector.');
end

coefficients = zeros(numel(class_names), 2);
for c = 1:numel(class_names)
    score = min(max(oof_scores(:, c), 1e-6), 1 - 1e-6);
    target = double(labels == class_names(c));
    coefficients(c, :) = glmfit(score, target, 'binomial', 'link', 'logit').';
end

calibrator = struct( ...
    'class_names', class_names, ...
    'coefficients', coefficients, ...
    'fit_scope', "GROUP_HELD_OUT_OOF_ONLY", ...
    'weight_scope', "FOLD_TRAINING_ROWS_ONLY");
end

function scores = align_scores(raw_scores, raw_class_names, class_names)
[present, location] = ismember(class_names, raw_class_names);
if ~all(present)
    error('PUBLIC_METHOD_CODE:ClassOrder', ...
        'Classifier scores do not cover the required class order.');
end
scores = raw_scores(:, location);
end
