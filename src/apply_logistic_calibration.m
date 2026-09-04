function probabilities = apply_logistic_calibration(scores, score_class_names, calibrator)
%APPLY_LOGISTIC_CALIBRATION Apply classwise logistic calibration and normalize rows.

score_class_names = string(score_class_names(:));
class_names = string(calibrator.class_names(:));
[present, location] = ismember(class_names, score_class_names);
if ~all(present) || size(scores, 2) ~= numel(score_class_names)
    error('PUBLIC_METHOD_CODE:CalibrationClassOrder', ...
        'scores and score_class_names are inconsistent with the calibrator.');
end

ordered_scores = min(max(double(scores(:, location)), 1e-6), 1 - 1e-6);
probabilities = zeros(size(ordered_scores));
for c = 1:numel(class_names)
    linear_score = calibrator.coefficients(c, 1) + ...
        calibrator.coefficients(c, 2) * ordered_scores(:, c);
    linear_score = min(max(linear_score, -35), 35);
    probabilities(:, c) = 1 ./ (1 + exp(-linear_score));
end

row_sum = sum(probabilities, 2);
if any(row_sum <= 0 | ~isfinite(row_sum))
    error('PUBLIC_METHOD_CODE:CalibrationProbability', ...
        'Calibrated probabilities must have positive finite row sums.');
end
probabilities = probabilities ./ row_sum;
end
