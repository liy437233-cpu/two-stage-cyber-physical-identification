function result = evaluate_five_state(y, five_state_probability)
%EVALUATE_FIVE_STATE Return ordered five-state predictions and a confusion matrix.

method = method_definition();
class_names = method.five_states;
labels = string(y(:));
if size(five_state_probability, 1) ~= numel(labels) || ...
        size(five_state_probability, 2) ~= numel(class_names)
    error('PUBLIC_METHOD_CODE:EvaluationDimensions', ...
        'Labels and five-state probabilities are inconsistent.');
end
if ~all(ismember(labels, class_names))
    error('PUBLIC_METHOD_CODE:EvaluationLabels', ...
        'Evaluation labels must use the frozen five-state order.');
end

[~, index] = max(five_state_probability, [], 2);
predicted_label = categorical(class_names(index), class_names, class_names);
confusion_matrix = zeros(numel(class_names));
for i = 1:numel(class_names)
    for j = 1:numel(class_names)
        confusion_matrix(i, j) = sum(labels == class_names(i) & ...
            string(predicted_label) == class_names(j));
    end
end

result = struct( ...
    'class_names', class_names, ...
    'predicted_label', predicted_label, ...
    'confusion_matrix', confusion_matrix);
end
