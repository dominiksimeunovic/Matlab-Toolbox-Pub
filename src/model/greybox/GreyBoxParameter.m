classdef GreyBoxParameter
    %GREYBOXPARAMETER Class representing a parameter of a grey-box model
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        name
        value
        min 
        max
    end
    
    methods
        function obj = GreyBoxParameter(name, value, min, max)
            %GREYBOXPARAMETER Construct an instance of this class
            %   param name: parameter name
            %   param value: inital quess of the parameter's value
            %   param min: min value the parameter can take
            %   param max: max value the parameter can take
            obj.name = name;
            obj.value = value;
            obj.min = min;
            obj.max = max;
        end
        
    end
end

