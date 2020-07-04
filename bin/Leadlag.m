classdef Leadlag <Bloco
    properties
        eq
        leadlag_lead
        leadlag_lag
    end
    methods
        function obj = Leadlag(arg1, arg2, arg3, arg4, arg5)
        
            obj.valorSaida = str2sym(arg5);
            obj.leadlag_lead = Lead(arg1, arg2);        %Contruct do bloco
            obj.leadlag_lag = Lag(arg3, arg4, arg5);        %Contruct do bloco

        end
        function obj = update(obj)
       
            obj.leadlag_lead.valorEntrada = obj.valorEntrada;
            update(obj.leadlag_lead);
            obj.leadlag_lag.valorEntrada = obj.leadlag_lead.valorSaida;
            update(obj.leadlag_lag);
            obj.valorSaida = obj.leadlag_lag.valorSaida;
            obj.eq = obj.leadlag_lag.eq;

        end
    end
end