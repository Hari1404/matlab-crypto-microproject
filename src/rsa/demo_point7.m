function demo_point7()
% DEMO_POINT7 Demonstration of Point 7: RSA public-key encryption.
%   Packet 7A shows the RSA keys, the encryption and decryption of a number and of a text, and why it works.
%   Packet 7B shows the RSA keys of all users and their messages, the key transport and the eavesdropper.
fprintf('\n##### POINT 7 DEMO: RSA PUBLIC-KEY ENCRYPTION #####\n');
S = define_sets();
show_rsa(S);
show_rsa_users(S);
show_rsa_transport(S);
show_rsa_eavesdropper(S);
end
