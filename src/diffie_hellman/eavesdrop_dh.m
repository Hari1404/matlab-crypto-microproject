function E = eavesdrop_dh(A, B, p, g)
% EAVESDROP_DH An eavesdropper breaks the Diffie-Hellman key exchange by trying every secret number.
%   E = eavesdrop_dh(A, B, p, g) knows only the public numbers p and g and the two public values A and B.
%   She computes g^1, g^2, g^3, ... mod p until she gets A. That gives the secret number a with g^a = A (mod p).
%   Then she computes the key B^a mod p. This is only possible for a small prime (p up to 1000000).
%   E.p, E.g, E.A, E.B   the numbers that she knows
%   E.secret             the secret number a that she found (a number from 1 to p-2)
%   E.tries              how many numbers she tried (it is the same as E.secret)
%   E.key                the key B^a mod p
%   E.worst              the most tries that any secret number needs: p-2
check_dh_setup(p, g);
if p > 1000000
    error('eavesdrop_dh:size', 'The prime p must be at most 1000000, because trying every secret number takes too long.');
end
if ~is_whole_number(A) || A < 2 || A > p - 1
    error('eavesdrop_dh:public', 'The public value A must be one whole number from 2 to p-1.');
end
if ~is_whole_number(B) || B < 1 || B > p - 1
    error('eavesdrop_dh:public', 'The public value B must be one whole number from 1 to p-1.');
end
v = 1;
secret = 0;
for t = 1:(p - 2)
    v = mod(v * g, p);
    if v == A
        secret = t;
        break
    end
end
E.p = p;
E.g = g;
E.A = A;
E.B = B;
E.secret = secret;
E.tries = secret;
E.key = dh_shared_key(secret, B, p);
E.worst = p - 2;
end
