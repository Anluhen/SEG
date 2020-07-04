classdef Limitador <Bloco
    properties
        min
        max
    end
    methods
        function obj = Limitador()
        end
        function obj = update(obj)
            obj.min = erase(string(obj.valorEntrada), "(t)")+"_min";
            obj.max = erase(string(obj.valorEntrada), "(t)")+"_max";
            obj.valorSaida = str2sym(erase(string(obj.valorEntrada), "(t)")+"L(t)");
        end
    end
end