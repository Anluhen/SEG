classdef Trig < Bloco
    properties
	funcao
    end
    methods
        function obj = Trig(arg1)
	obj.funcao = arg1;
        end
        function obj = update(obj)
            obj.valorSaida = obj.funcao(obj.valorEntrada);
        end
    end
end