function P = arrow_points(p, q, r, off)
% ARROW_POINTS The line and the arrowhead of the arrow for an arc from the place p to the place q.
%   p and q are places [x y] of two circles of radius r. off is the sideways shift of the arrow to the left of the
%   direction p -> q (0 for an arrow in the middle, 0.12 for one of two parallel arrows of a two-way channel).
%   P.start      where the line starts, on the circle around p
%   P.line_end   where the line ends (the middle of the base of the arrowhead)
%   P.tip        the tip of the arrowhead, on the circle around q
%   P.head       3 by 2 corners of the arrowhead triangle: the tip and the two corners of the base
%   The arrowhead is 0.35 long and 0.28 wide. Errors: arrow_points:size (p or q is not one place [x y], r is not
%   positive, or off is not a number smaller than r), arrow_points:same (p and q are the same place) and
%   arrow_points:short (the circles are too close for an arrow).
if ~isequal(size(p), [1 2]) || ~isequal(size(q), [1 2]) || ~isscalar(r) || ~isscalar(off)
    error('arrow_points:size', 'p and q must be places [x y], and r and off must be single numbers.');
end
if r <= 0 || abs(off) >= r
    error('arrow_points:size', 'r must be positive and the shift off must be smaller than r.');
end
len = norm(q - p);
if len == 0
    error('arrow_points:same', 'The two places are the same, so no arrow can be drawn.');
end
head_length = 0.35;
head_half_width = 0.14;
d = (q - p) / len;
nrm = [-d(2), d(1)];
s = sqrt(r ^ 2 - off ^ 2);
if len <= 2 * s + head_length
    error('arrow_points:short', 'The circles are too close for an arrow.');
end
shift = off * nrm;
P.start = p + shift + s * d;
P.tip = q + shift - s * d;
P.line_end = P.tip - head_length * d;
P.head = [P.tip; P.line_end + head_half_width * nrm; P.line_end - head_half_width * nrm];
end
