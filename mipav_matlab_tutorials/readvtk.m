function Mesh = FUN_readvtk(Filename)

% read vtk file
% output structure Mesh
% Mesh.VtxNum:      Number of vertices
% Mesh.VtxCoords:   vertex coordinates
% Mesh.TriNum:      Number of triangles
% Mesh.TriVtxIds:   Vertex IDs associate with each triangle
% Mesh.VtxClrs:     Colors or feature vector on each vertex


fid = fopen(Filename, 'r');
if (fid == -1)
    error('failed in reading file. check file name!')
    return
end

fgetl(fid); % # vtk DataFile Version x.x
fgetl(fid); % comments
fgetl(fid); % ASCII

% make sure it's polydata
s = fgetl(fid);  % DATASET STRUCTURED_POINTS/POLYDATA
Start = regexp(s, 'POLYDATA', 'once');

if isempty(Start)
    error('Not polydata')
    fclose(fid);
    return
end

%% get vertex number and read vertex coordinates
s = fgetl(fid);
VtxNum = sscanf(s, '%*s%d%*s');
DataType = sscanf(s, '%*s%*d%s'); DataType = char(DataType');
VtxCoords = fscanf(fid, '%f', [3, VtxNum]);
Mesh.VtxCoords = VtxCoords;
Mesh.VtxNum = VtxNum;

%% get triangle number and read triangular mesh
Found = 0;
while ~Found
    s = fgetl(fid);
    if length(s) >= 8 && strcmp(s(1:8), 'POLYGONS')
        Found = 1;
    end
end

TriNum = sscanf(s, '%*s%d%d'); TriNum = TriNum(1);
TriVtxIds = fscanf(fid, '%d', [4, TriNum]);
TriVtxIds(1, :) = [];
TriVtxIds = TriVtxIds + 1;
Mesh.TriVtxIds = TriVtxIds;
Mesh.TriNum = TriNum;

%% read the vertex value
Found = 0;
while ~Found
    s = fgetl(fid);    
    if s == -1 % no embedded data found
        fclose(fid);
        return
    end
    if length(s) >= 10 && strcmp(s(1:10), 'POINT_DATA')
        Found = 1;
    end
end

s = fgetl(fid); % SCALARS EmbedVertex float 
FtrNum = sscanf(s, '%*s%*s%*s%d');
fgetl(fid); % LOOKUP_TABLE default

VtxClrs = fscanf(fid, '%f', [FtrNum, VtxNum]);
Mesh.VtxClrs = VtxClrs;

% close file
fclose(fid);

