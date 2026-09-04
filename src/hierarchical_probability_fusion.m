function five_state_probability = hierarchical_probability_fusion(stage1_probability, stage2_probability)
%HIERARCHICAL_PROBABILITY_FUSION Combine calibrated Stage 1 and Stage 2 probabilities.

if size(stage1_probability, 2) ~= 3 || size(stage2_probability, 2) ~= 3
    error('PUBLIC_METHOD_CODE:FusionDimensions', ...
        'Stage 1 and Stage 2 probabilities must each have three columns.');
end
if size(stage1_probability, 1) ~= size(stage2_probability, 1)
    error('PUBLIC_METHOD_CODE:FusionRows', ...
        'Stage probability matrices must have the same number of rows.');
end

no_network_attack = stage1_probability(:, 3);
five_state_probability = [ ...
    no_network_attack .* stage2_probability(:, 1), ...
    stage1_probability(:, 1), ...
    stage1_probability(:, 2), ...
    no_network_attack .* stage2_probability(:, 2), ...
    no_network_attack .* stage2_probability(:, 3)];

row_sum = sum(five_state_probability, 2);
if any(row_sum <= 0 | ~isfinite(row_sum))
    error('PUBLIC_METHOD_CODE:FusionProbability', ...
        'Fused probabilities must have positive finite row sums.');
end
five_state_probability = five_state_probability ./ row_sum;
end
