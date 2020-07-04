classdef Ganho < Bloco
    properties
        ganho
    end
    methods
        function obj = Ganho(arg1)
            arg1 = str2sym(arg1);
            obj.ganho = sym(arg1);
        end
        function obj = update(obj)
            obj.valorSaida = obj.ganho * obj.valorEntrada;
        end
    end
end