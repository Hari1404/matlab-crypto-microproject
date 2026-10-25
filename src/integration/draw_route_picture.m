function [h, opts] = draw_route_picture(ax, Y, R)
% DRAW_ROUTE_PICTURE Draw the network Y with the route R marked in the axes ax.
%   The users are at the places of the whole network (graph_layout of Y.G.adj), so they never move when channels break.
%   R is the result of route_message, or [] for no route (see route_picture_options).
%   h are the handles from draw_network and opts the options that were used.
opts = route_picture_options(Y, R);
xy = graph_layout(Y.G.adj);
h = draw_network(ax, Y.G, xy, opts);
end
