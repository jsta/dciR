function DCI = DCIu(distance, dx, pixelx)

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%DCIu.m
%Written and updated June 2012 by Laurel Larsen, lglarsen@usgs.gov
%US Geological Survey, Reston, VA
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% This function calculates the unweighted directional connectivity index,
% in which connectivity at all scales (down to the length of a pixel)
% contributes equally to the index. Inputs are a distance matrix and 
% array of node locations from im2adjacency_skel.m or im2adjacency_full.m, 
% depending on whether the "full" or "skel" convention for defining links and 
% nodes is employed. The output is the directional connectivity index
% (DCI), scaled between 0 and 1.
% 
% This function requires the MatlabBGL library (Gleich, 2011) to be 
% installed. This open-source library can be downloaded at 
% http://dgleich.github.com/matlab-bgl/
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

dx = dx/100; %Converts to meters so that we're not dealing with such large numbers.
distance = distance/100; %Converts to meters so that we're not dealing with such large numbers.
R = max(pixelx); %The number of rows in the original image
start_nodes = find(pixelx~=R); %Nodes in the last row of the image cannot be starting/source nodes.
num = 0; %Initialize numerator of summation
den = 0; %Initialize denominator of summation
for ii = 1:length(start_nodes)
    d = dijkstra(distance, start_nodes(ii),[]); %A vector of the shortest path between starting/source node and all other nodes
    r = pixelx(start_nodes(ii)); %The row of the starting/source node
    for jj = r+1:R
        end_nodes = find(pixelx == jj);
        if ~isempty(end_nodes)
            dij = min(d(end_nodes)); %Shortest distance (structural or functional) between starting/source node and any node in the next row
            num = num+dx*(jj-r)/dij;
            den = den+1;
        end
    end
end
DCI = num/den;
        
            
        