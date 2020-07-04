classdef Lead <Bloco
    properties
        p1
        p2
    end
    methods
        function obj = Lead(arg1, arg2)
            obj.p1 = str2sym(arg1);
            obj.p2 = str2sym(arg2);
        end
        function obj = update(obj)
            %obj.eq = diff(obj.valorEntrada) == (obj.valorSaida - obj.p2*obj.valorEntrada)/obj.p1;
            obj.valorSaida = diff(obj.valorEntrada)*obj.p1 + obj.valorEntrada*obj.p2;
        end
    end
end