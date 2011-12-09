function d = grPropagateDistance(v, e, v0, l)
%GRPROPAGATEDISTANCE  Propagates distances from a vertex to other vertices
%
%   DISTS = grPropagateDistance(V, E, V0, L)
%   V0 is index of initial vertex
%   E is array of source and target vertices
%   L is the vector of length of each edge. If not specified, length 1 is
%       assumed for all edges.
%   The result DISTS is a column array with as many rows as the number of
%   vertices, containing the geodesic distance of each vertex to the vertex
%   of index V0.
%
%   Example
%   grPropagateDistance
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-09-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% initialize empty array for result
Nv = length(v);
d = ones(Nv, 1)*inf;
d(v0) = 0;

% ensure there is a valid length array
if nargin<4
    l = ones(size(e,1), 1);
end

% iterate from germ vertex until there are no more vertices to process
verticesToProcess = v0;
while ~isempty(verticesToProcess)
    % init new iteration
    newVerticesToProcess = [];

    % iterate over vertices that need to be updated
    for i=1:length(verticesToProcess)
        vertex = verticesToProcess(i);
        
        % iterate over neighbor edges of current vertex
        vertexEdges = getNeighbourEdges(vertex, e);
        for j=1:length(vertexEdges)
            iEdge = vertexEdges(j);
            
            % compute distance between current vertex and its neighbor
            vertex2 = getOppositeNode(vertex, e(iEdge,:));
            newDist = d(vertex) + l(iEdge);
            
            % update geodesic distance of neighbor node if needed
            if newDist < d(vertex2)
                d(vertex2) = newDist;
                newVerticesToProcess = [newVerticesToProcess ; vertex2]; %#ok<AGROW>
            end
        end
    end
    
    % update set of vertices for next tieration
    verticesToProcess = newVerticesToProcess;
end
