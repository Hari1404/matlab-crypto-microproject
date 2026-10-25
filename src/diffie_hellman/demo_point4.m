function demo_point4()
% DEMO_POINT4 Demonstration of Point 4: Diffie-Hellman key exchange and encryption.
%   Packet 4A shows the Diffie-Hellman key exchange: two users and then all users.
fprintf('\n##### POINT 4 DEMO: DIFFIE-HELLMAN KEY EXCHANGE AND ENCRYPTION #####\n');
S = define_sets();
show_dh(S);
end
