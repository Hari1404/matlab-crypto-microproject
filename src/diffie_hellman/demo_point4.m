function demo_point4()
% DEMO_POINT4 Demonstration of Point 4: Diffie-Hellman key exchange and encryption.
%   Packet 4A shows the Diffie-Hellman key exchange: two users and then all users.
%   Packet 4B shows the encryption with the shared key and an eavesdropper.
fprintf('\n##### POINT 4 DEMO: DIFFIE-HELLMAN KEY EXCHANGE AND ENCRYPTION #####\n');
S = define_sets();
show_dh(S);
show_encryption(S);
show_eavesdropper(S);
end
