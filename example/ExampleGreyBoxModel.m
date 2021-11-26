classdef ExampleGreyBoxModel < GreyBoxModel
    %EXAMPLEGREYBOXMODEL Example of a grey-box model class
    %   This class is an example of how to use the grey-box model class to
    %   construct your own models
   
    methods
        function obj = ExampleGreyBoxModel()
            %EXAMPLEGREYBOXMODEL Construct an instance of this class
            
            obj = obj@GreyBoxModel(@ExampleGreyBoxModel.odefunction, @ExampleGreyBoxModel.odeparameters, 1, 3, 1, 2);
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
            parameters{3} = GreyBoxParameter('R_w_amb', 5.4e-04, 0, NaN);
            parameters{4} = GreyBoxParameter('R_w_air', 1.7e-04, 0, NaN);
            parameters{5} = GreyBoxParameter('R_w', 0.02, 0, 0.1);
            parameters{6} = GreyBoxParameter('C_w', 2.1e+07, 0, NaN);
            parameters{7} = GreyBoxParameter('f_sol', 0.01, 0, NaN);
        end
    
        function [A,B,C,D] = odefunction (C_air, R_air_amb, R_w_amb, ...
                    R_w_air, R_w, C_w, f_sol, Ts)
            %ODEFUNCTION Function defining the model's state-space equations
            %   Must be static!
            
            syms dT_air T_air                       % output and derivative
            syms dT_w_in T_w_in dT_w_out T_w_out    % states and derivatives
            syms Phi_h phi_global T_amb             % inputs u
            
            alpha_f             = 0.5;
            alpha_a             = 25;
            f_heat_rad          = 0.2;

            Phi_h_air           = Phi_h*(1-f_heat_rad);
            Phi_h_wall          = Phi_h * f_heat_rad;
            Phi_sol             = f_sol*phi_global;

            T_amb_eq    = T_amb + phi_global*alpha_f/alpha_a;
            
            dT_air      = 1 / C_air * ( (T_w_in - T_air)/R_w_air ... 
                    + (T_amb - T_air)/R_air_amb + Phi_sol + Phi_h_air );
            dT_w_in     = 1 / C_w *( (T_air - T_w_in)/R_w_air + (T_w_out - T_w_in)/R_w + Phi_h_wall );
            dT_w_out    = 1 / C_w * ( (T_amb_eq - T_w_out)/R_w_amb + (T_w_in - T_w_out)/R_w );

            f = [dT_air, dT_w_in, dT_w_out];
            x = [T_air, T_w_in, T_w_out];
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



