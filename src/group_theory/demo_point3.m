function demo_point3()
% DEMO_POINT3 Demonstration of Point 3: group theory and modular arithmetic.
%   Packet 3A shows the modular arithmetic tools: fast modular exponentiation, Euclid's gcd, the extended gcd and the inverse.
%   Packet 3B shows the group Z_p* (the group rules), and the orders, generators and cyclic subgroups.
fprintf('\n##### POINT 3 DEMO: GROUP THEORY AND MODULAR ARITHMETIC #####\n');
S = define_sets();
show_modular(S);
show_group(S);
show_cyclic(S);
end
