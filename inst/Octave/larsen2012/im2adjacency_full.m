function [distance adjacency pixelx pixely] = im2adjacency_full(state, dx, dy)

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%im2adjacency_full.m
%Written and updated June 2012 by Laurel Larsen, lglarsen@usgs.gov
%US Geological Survey, Reston, VA
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%Convert a binary image to an adjacency matrix, defining links and nodes 
%using the "full" convention, whereby a node is any "on" pixel (i.e., with
% a value of 1 in the "state" matrix. The output matrix 'distance' 
% contains the undirected distances between linked nodes. The code is 
% currently set up to compute the distance matrix from structural 
% distances. A future version will contain a modification for readily 
% computing functional adjacency matrices. 'Adjacency' is a logical matrix 
% with ones on the diagonals and ones indicating that two nodes are linked. 
% "Pixely" is a vector of y-coordinates of the nodes; "pixelx" is a vector 
% of x-coordinates of the nodes. Input variable definitions are as follows:

% state: a 2D matrix of zeros and ones, in which ones represent the
% landscape patch of interest. The axis of interest along which directional
% connectivity is computed is dimension 1 of this matrix.

% dx: pixel length in cm (i.e., along dimension 1 of the variable "state").

% dy: pixel width in cm (i.e., along dimension 2 of the variable "state").

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %1. Assign nodes to "on" state pixels
node = state';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2. Locate the nodes and their neighbors

%a. Find the number of 8-connected neighbors of each node.
padded = zeros(size(node)+[2 2]); 
padded(2:size(padded,1)-1, 2:size(padded,2)-1) = node;
neighbors = cat(3, padded(1:size(padded,1)-2, 1:size(padded,2)-2), padded(1:size(padded,1)-2, 2:size(padded,2)-1), padded(1:size(padded,1)-2, 3:size(padded,2)), padded(2:size(padded,1)-1, 1:size(padded,2)-2), padded(2:size(padded,1)-1, 3:size(padded,2)), padded(3:size(padded,1), 1:size(padded,2)-2), padded(3:size(padded,1), 2:size(padded,2)-1), padded(3:size(padded,1), 3:size(padded,2)));
n_connected = sum(neighbors,3);

%b. Save pixel coordinates of the nodes 
ind = find(node);
[pixely pixelx] = ind2sub(size(node), ind);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%3. Calculate link distances
dd = sqrt(dx^2+dy^2); %diagonal pixel distance
startlink = [];
endlink = [];
distlink = [];
for ii = 1:length(ind) %Do this for all nodes
    searchfromy = pixely(ii); searchfromx = pixelx(ii); %Coordinates of the pixel being searched from
    n_traced = 0; %number of links traced so far
    which_neighbors = find(neighbors(searchfromy, searchfromx,:));
    while n_traced < n_connected(searchfromy, searchfromx) %Trace a new path to the next downwind node unless all paths have already been traced.
        n_traced = n_traced+1;
        dist = 0;
        which_neighbor = which_neighbors(n_traced);
        newy = searchfromy; newx = searchfromx;
        keep_searching = 1;
        while keep_searching 
            switch which_neighbor %Figure out distance of this component as the pixel diagonal, length, or width
                case{1}
                    newy = newy-1; newx = newx-1;
                    dist = dist+dd;
                case{2}
                    newy = newy-1; 
                    dist = dist+dy;
                case{3}
                    newy = newy-1; newx = newx+1;
                    dist = dist+dd;
                case{4}
                    newx = newx-1;
                    dist = dist+dx;
                case{5} 
                    newx = newx+1;
                    dist = dist+dx;
                case{6} 
                    newy = newy+1; newx = newx-1;
                    dist = dist+dd;
                case{7}
                    newy = newy+1; 
                    dist = dist+dy;
                case{8}
                    newy = newy+1; newx = newx+1;
                    dist = dist+dd;
            end
            endpoint = find(ind == sub2ind(size(node), newy, newx));
            keep_searching = 0;
            endlink = [endlink; endpoint]; %Array of link ending index
            startlink = [startlink; ii]; %Array of link starting index
            distlink = [distlink; dist]; %Array of link distances
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%4. Output: Store adjacency and linkage matrices as memory-saving sparse
%data structures
distance = sparse(startlink, endlink, distlink, ii, ii);
adjacency = sparse([startlink;(1:ii)'], [endlink; (1:ii)'], 1,ii,ii);
        
