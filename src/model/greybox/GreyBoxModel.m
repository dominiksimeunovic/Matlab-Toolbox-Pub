classdef (Abstract) GreyBoxModel < handle
    %GREYBOXMODEL Class for representing and estimating a grey-box model
        
    properties (SetAccess = private)
        odefunction
        odeparameters
        EstModel
        nInputs
        nStates
        nOutputs
        nDisturbances
    end
    
    methods
        function obj = GreyBoxModel(odefunction, odeparameters, nInputs, nStates, nOutputs, nDisturbances)
            %GREYBOXMODEL Construct and initalize an instance of this class
            %   param odefunction: function handle of function retunring
            %       the state-space equations
            %   param odeparameters: function handle of function returning
            %       the sate-space equations' parameters
            %   param nInputs: number of the controllable inputs
            %   param nStates: number of the states
            %   param nOutputs: number of the outputs
            %   param nDisturbances; number of the uncontrollable inputs
            
            obj.odefunction = odefunction;
            obj.odeparameters = odeparameters;
            obj.nInputs = nInputs;
            obj.nStates = nStates;
            obj.nOutputs = nOutputs;
            obj.nDisturbances = nDisturbances;
            obj.initialize();
        end
        
        function [ssm, est] = estimate(obj, U, Y, Ts, X0)
            %ESTIMATE Estimate the grey-box model
            %   param obj: instance of this class
            %   param U: input data
            %   param Y: corresponding output data
            %   param Ts: sample time in seconds
            %   param X0: inital states
            %   param ssm: estimated state-space model
            %   param est: estimated idgrey model (incl. report)
            
            estData = iddata(Y, U, Ts);

            Options = greyestOptions( 'InitialState', X0);
            Options.SearchOption.MaxIter = 100;
            Options.Display = 'off';
            Options.Focus = 'simulation';
            Options.DisturbanceModel = 'none'; 
            Options.SearchMethod = 'auto';

            est = greyest(estData, obj.EstModel, Options);
            ssm = ss(est.A, est.B, est.C, est.D);
        end
    end
    
    methods (Access = private)
        function initialize(obj)
            %INITIALIZE Initialize EstModel with parameters
            %   param obj: instance of this class
            
            [Parameters] = obj.odeparameters();
            parameters = {};
            for i = 1:numel(Parameters)
                parameters{i, 1} = Parameters{i}.name;
                parameters{i, 2} = Parameters{i}.value;
            end            
            
            obj.EstModel = idgrey(obj.odefunction, parameters, 'c');
            
            for i = 1:numel(Parameters)
                if (isnumeric(Parameters{i}.min))
                    obj.EstModel.Structure.Parameters(i).Minimum = Parameters{i}.min;
                end
                if (isnumeric(Parameters{i}.max))
                    obj.EstModel.Structure.Parameters(i).Maximum = Parameters{i}.max;
                end
            end               
        end
    end
end

