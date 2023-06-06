function y = to_fixed (x, e)
	if (nargin != 2)
		usage ("to_fixed (x, e)")
	endif
        a = x * (2 ** e);
        y = int64(round(a));
endfunction
