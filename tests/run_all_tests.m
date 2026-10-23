function run_all_tests()
% RUN_ALL_TESTS Run every test of the project. Run setup_project first.
test_sets();
test_relations();
test_cipher();
test_graph();
test_graph_analysis();
fprintf('\nALL TESTS PASSED\n');
end
