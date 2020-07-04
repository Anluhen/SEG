classdef Input < Bloco
    properties
        
    end
    methods
         function obj = Input(arg1)
            obj.valorSaida = str2sym(arg1);
         end
    end
end