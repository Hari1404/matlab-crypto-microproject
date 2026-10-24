function flag = is_whole_number(x)
% IS_WHOLE_NUMBER True when x is one real number with a whole value (like 0, 7 or -3) that is small enough to be exact (at most 2^53).
flag = isnumeric(x) && isreal(x) && isscalar(x) && isfinite(x) && x == floor(x) && abs(x) <= 2^53;
end
