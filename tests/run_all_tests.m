function run_all_tests()
% RUN_ALL_TESTS Run every test of the project. Run setup_project first.
test_sets();
test_relations();
test_cipher();
test_graph();
test_graph_analysis();
test_graph_pictures();
test_modular();
test_group();
test_dh();
test_encryption();
test_system();
test_main_demo();
test_route_picture();
fprintf('\nALL TESTS PASSED\n');
end
