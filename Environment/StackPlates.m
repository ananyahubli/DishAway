classdef StackPlates < handle
    %ROBOTCOWS A class that creates a herd of robot
    %   The cows can be moved around randomly. It is then possible to query
    %   the current location (base) of the cows.

    %#ok<*TRYNC>

    properties
        cowCount = 2;
        cowModel;
        workspaceDimensions;
    end

    methods

        function self = StackPlates(cowCount,posCow)

            if 0 < nargin
                self.cowCount = cowCount;
            end
            self.workspaceDimensions = [-10, 10, -10, 10, 0, 10];

            for i = 1:self.cowCount
                self.cowModel{i} = self.GetCowModel(['cow',num2str(i)]);


                basePose = posCow{i};
                self.cowModel{i}.base = basePose; 

                plot3d(self.cowModel{i},0,'workspace',self.workspaceDimensions,'view',[-30,30],'delay',0,'noarrow','nowrist');

                if i == 1
                    hold on;
                end
            end
            axis equal
        end
    end

    methods(Static)
        %% GetCowModel Lab 2
        function model = GetCowModel(name)
            if nargin < 1
                name = 'Cow';
            end
            [faceData,vertexData] = plyread('plate.ply','tri');

            link1 = Link('alpha',0,'a',0,'d',0,'offset',0);

            model = SerialLink(link1,'name',name);

            model.faces = {[], faceData};

            model.points = {[], vertexData};
        end
    end
end