classdef Integrador <Bloco
    properties
        eq
    end
    methods
        function obj = Integrador(arg1)
            arg1 = str2sym(arg1);
            obj.valorSaida = arg1;
        end
        function obj = update(obj)
            %obj.eq = obj.dVarEstado == obj.valorEntrada;
            obj.eq = diff(obj.valorSaida) == obj.valorEntrada;
        end
    end
end