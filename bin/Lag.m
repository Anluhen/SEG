classdef Lag <Bloco
    properties
        p1
        p2
        eq
    end
    methods
        function obj = Lag(arg1, arg2, arg3)
            obj.p1 = str2sym(arg1);
            obj.p2 = str2sym(arg2);
            arg3 = str2sym(arg3);
            obj.valorSaida = arg3;
        end
        function obj = update(obj)
            obj.eq = diff(obj.valorSaida) == (obj.valorEntrada - obj.p2*obj.valorSaida)/obj.p1;
        end
    end
end