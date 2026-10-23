function flag = raises_error(f)
% RAISES_ERROR True when calling the function handle f stops with an error.
flag = false;
try
    f();
catch
    flag = true;
end
end
