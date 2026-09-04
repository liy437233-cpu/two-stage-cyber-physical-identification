function method = method_definition()
%METHOD_DEFINITION Frozen public method contract.

method.five_states = ["NORMAL"; "REPLAY"; "SPOOFING"; ...
    "MOTOR_ACTUATOR_FAULT"; "POSITION_SENSOR_FAULT"];

method.domain_counts = struct( ...
    'network', 45, ...
    'physical_dynamic', 56, ...
    'cyber_physical_consistency', 92, ...
    'normal_behavior_residual', 71);
method.base_feature_count = 193;
method.total_feature_count = 264;
method.top_k = 128;

method.stage1.classes = ["REPLAY"; "SPOOFING"; "NO_NETWORK_ATTACK"];
method.stage1.domains = ["NETWORK"; "CYBER_PHYSICAL_CONSISTENCY"];
method.stage1.beta_by_class = struct( ...
    'REPLAY', 1.0, 'SPOOFING', 1.0, 'NO_NETWORK_ATTACK', 1.0);

method.stage2.classes = ["NORMAL"; "MOTOR_ACTUATOR_FAULT"; "POSITION_SENSOR_FAULT"];
method.stage2.domains = ["PHYSICAL_DYNAMIC"; "NORMAL_BEHAVIOR_RESIDUAL"];
method.stage2.allowed_beta_motor = [1.0, 1.5];
method.stage2.example_beta_motor = 1.0;
method.weighting.alpha = 0.5;

method.bagged_tree.num_learners = 100;
method.bagged_tree.min_leaf_size = 10;
method.bagged_tree.num_predictors_to_sample = 10;
end
