function selected_index = select_top_k(ranking_order, k)
%SELECT_TOP_K Return the first k externally supplied ranked feature indices.

ranking_order = double(ranking_order(:));
validateattributes(ranking_order, {'numeric'}, {'vector', 'integer', 'positive'});
validateattributes(k, {'numeric'}, {'scalar', 'integer', 'positive'});

if k > numel(ranking_order) || numel(unique(ranking_order)) ~= numel(ranking_order)
    error('PUBLIC_METHOD_CODE:RankingOrder', ...
        'ranking_order must contain unique indices and include at least k entries.');
end

selected_index = ranking_order(1:k);
end
