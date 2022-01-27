classdef GreyBoxModel_1R1C < GreyBoxModel
     
   
    methods
        function obj = GreyBoxModel_1R1C()
            %EXAMPLEGREYBOXMODEL Construct an instance of this class
            
            obj = obj@GreyBoxModel(@GreyBoxModel_1R1C.odefunction, @GreyBoxModel_1R1C.odeparameters, 1, 1, 1, 2);
        end
    end
    
    methods (Static)        
        function [parameters] = odeparameters()
            %ODEPARAMETERS Function defining the gewy-box model's parameters
            %   Must be static!
            %   params parameters: the grey-box model function's parameters
            
        	parameters = {};
            parameters{1} = GreyBoxParameter('C_air', 500000, 0, NaN); 
            parameters{2} = GreyBoxParameter('R_air_amb', 0.005, 0, NaN);
            parameters{3} = GreyBoxParameter('f_sol', 0.01, 0, 0.25);
        end
    
        function [A,B,C,D] = odefunction (C_air, R_air_amb, f_sol) 
            %ODEFUNCTION Function defining the model's state-space equations
            %   Must be static!
            
            syms dT_air T_air                       % output and derivatives
            syms Phi_h phi_global T_amb             % inputs

           
            Phi_sol             = f_sol*phi_global; 
            
            dT_air      = (1/C_air)*(1/R_air_amb)*(T_amb-T_air) + (1/C_air)*(Phi_sol+Phi_h); %What about dt?

            f = [dT_air];
            x = [T_air];
            u = [Phi_h, phi_global, T_amb];
            g = [T_air];

            
            % partial derivations
            A = double(jacobian(f,x));
            B = double(jacobian(f,u));
            C = double(jacobian(g,x));
            D = double(jacobian(g,u));
        end
    end
end

