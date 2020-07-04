classdef Somador < Bloco
    
    properties
        nEntradas
        partialOut
        connectionCount
    end
    
    methods
        function obj = Somador(arg1)
            obj.nEntradas = str2double(arg1);
            obj.connectionCount = 0;
            obj.partialOut = 0;
        end
        function obj = update(obj)
            obj.partialOut = obj.partialOut + obj.valorEntrada;
            obj.connectionCount = obj.connectionCount + 1;
            if obj.connectionCount == obj.nEntradas
                obj.valorSaida = obj.partialOut;
            end
            obj.valorEntrada = [];
        end
    end
end
