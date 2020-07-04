classdef Bloco < handle
    %%%%%%%%%%%%%%%
    properties
        nome
        tipo
        inConnection
        outConnection
        valorEntrada
        valorSaida
    end
    %%%%%%%%%%%%%%%
    methods
         function obj = Bloco()
        end
        function obj = update(obj)
        end
    end
end