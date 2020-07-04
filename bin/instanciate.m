function [bloco, X, P, V, ini_var] = instanciate(dados)

bloco = cell(1, round(length(dados)/2,0));

X = [];
P = [];
V = [];
ini_var = [];

for i = 1:size(dados,2)
    
    if dados{i}(1) == "Limitador"                %Cria os blocos limitadores
        
        if length(dados{i}) >= 2
            
            bloco{i} = Limitador();        %Contruct do bloco
            bloco{i}.nome = dados{i}(2);            %Nome do bloco
            for j = 3:length(dados{i})
                bloco{i}.outConnection = [bloco{i}.outConnection, dados{i}(j)];   %Conexão da saída
            end
            bloco{i}.tipo = dados{i}(1);            %Tipo do bloco
            
        else
            fprintf('Erro tamanho %s \n', dados{i}(2))
        end
        
    elseif dados{i}(1) == "Trig"                 %Cria os blocos somadores
        
        if length(dados{i}) >= 2
            
            bloco{i} = Trig(dados{i}(2));        %Contruct do bloco
            bloco{i}.nome = dados{i}(2);            %Nome do bloco
            for j = 3:length(dados{i})
                bloco{i}.outConnection = [bloco{i}.outConnection, dados{i}(j)];   %Conexão da saída
            end
            bloco{i}.tipo = dados{i}(1);            %Tipo do bloco
            
        else
            fprintf('Erro tamanho %s \n', dados{i}(2))
        end
        
    elseif dados{i}(1) == "Leadlag"                 %Cria os blocos somadores
        
        if length(dados{i}) >= 8
            
            bloco{i} = Leadlag(dados{i}(3), dados{i}(4), dados{i}(5), dados{i}(6), dados{i}(7));        %Contruct do bloco
            bloco{i}.nome = dados{i}(2);            %Nome do bloco
            for j = 8:length(dados{i})
                bloco{i}.outConnection = [bloco{i}.outConnection, dados{i}(j)];   %Conexão da saída
            end
            bloco{i}.tipo = dados{i}(1);            %Tipo do bloco
            
            syms(dados{i}(7))
            
        else
            fprintf('Erro tamanho %s \n', dados{i}(2))
        end
        
    elseif dados{i}(1) == "Lead"                 %Cria os blocos somadores
        
        if length(dados{i}) >= 6
            
            bloco{i} = Lead(dados{i}(3), dados{i}(4));%Contruct do bloco
            bloco{i}.nome = dados{i}(2);            %Nome do bloco
            for j = 6:length(dados{i})
                bloco{i}.outConnection = [bloco{i}.outConnection, dados{i}(j)];   %Conexão da saída
            end
            bloco{i}.tipo = dados{i}(1);            %Tipo do bloco
            
            try
                syms(dados{i}(3), dados{i}(4), dados{i}(5))
            end
            
        else
            fprintf('Erro tamanho %s \n', dados{i}(2))
        end
        
    elseif dados{i}(1) == "Lag"                 %Cria os blocos somadores
        
        if length(dados{i}) >= 6
            
            bloco{i} = Lag(dados{i}(3), dados{i}(4), dados{i}(5));        %Contruct do bloco
            bloco{i}.nome = dados{i}(2);            %Nome do bloco
            for j = 6:length(dados{i})
                bloco{i}.outConnection = [bloco{i}.outConnection, dados{i}(j)];   %Conexão da saída
            end
            bloco{i}.tipo = dados{i}(1);            %Tipo do bloco
            
            try
                syms(dados{i}(3), dados{i}(4), dados{i}(5))
            end
            
        else
            fprintf('Erro tamanho %s \n', dados{i}(2))
        end
        
    elseif dados{i}(1) == "Integrador"                 %Cria os blocos somadores
        
        if length(dados{i}) >= 4
            
            bloco{i} = Integrador(dados{i}(3));        %Contruct do bloco
            bloco{i}.nome = dados{i}(2);            %Nome do bloco
            for j = 4:length(dados{i})
                bloco{i}.outConnection = [bloco{i}.outConnection, dados{i}(j)];   %Conexão da saída
            end
            bloco{i}.tipo = dados{i}(1);            %Tipo do bloco
            
            syms(dados{i}(3))
            
        else
            fprintf('Erro tamanho %s \n', dados{i}(2))
        end
        
    elseif dados{i}(1) == "Somador"             %Cria os blocos somadores
        
        if length(dados{i}) >= 4
            
            bloco{i} = Somador(dados{i}(3));        %Contruct do bloco
            bloco{i}.nome = dados{i}(2);            %Nome do bloco
            for j = 4:length(dados{i})
                bloco{i}.outConnection = [bloco{i}.outConnection, dados{i}(j)];   %Conexão da saída
            end
            bloco{i}.tipo = dados{i}(1);            %Tipo do bloco
            
        else
            fprintf('Erro tamanho %s \n', dados{i}(2))
        end
        
    elseif dados{i}(1) == "Ganho"               %Cria os blocos de ganho
        
        if length(dados{i}) >= 4
            
            bloco{i} = Ganho(dados{i}(3));          %Contruct do bloco
            bloco{i}.nome = dados{i}(2);            %Nome do bloco
            for j = 4:length(dados{i})
                bloco{i}.outConnection = [bloco{i}.outConnection, dados{i}(j)];   %Conexão da saída
            end
            bloco{i}.tipo = dados{i}(1);            %Tipo do bloco
            
            syms(dados{i}(4))
            
        else
            fprintf('Erro tamanho %s \n', dados{i}(2))
        end
        
    elseif dados{i}(1) == "Input"               %Cria os blocos de input
        
        if length(dados{i}) >= 3
            
            bloco{i} = Input(dados{i}(2));          %Construct do bloco
            bloco{i}.nome = dados{i}(2);            %Nome do bloco
            for j = 3:length(dados{i})
                bloco{i}.outConnection = [bloco{i}.outConnection, dados{i}(j)];   %Conexão da saída
            end
            bloco{i}.tipo = dados{i}(1);            %Tipo do bloco
            
            syms(dados{i}(2))
                        
        else
            fprintf('Erro tamanho %s \n', dados{i}(2))
        end
        
    elseif dados{i}(1) == "Output"              %Cria os blocos de output
        
        if length(dados{i}) >= 2
            
            bloco{i} = Output(dados{i}(2));         %Construct do bloco com o nome
            bloco{i}.tipo = dados{i}(1);            %Tipo do bloco
            
        else
            fprintf('Erro tamanho %s \n', dados{i}(2))
        end
        
    elseif dados{i}(1) == "X"        %Variáveis de estado
        
        for j = 2:length(dados{i})
            X = [X, dados{i}(j)];
        end
        
    elseif dados{i}(1) == "P"        %Parâmetros
        
        for j = 2:length(dados{i})
            P = [P, dados{i}(j)];
        end
        
    elseif dados{i}(1) == "V"        %Entradas
        
        for j = 2:length(dados{i})
            V = [V, dados{i}(j)];
        end
        
    elseif dados{i}(1) == "Inicial"     %Variáveis com valores iniciais a serem calculados
        ini_var = [ini_var, dados{i}(2)];
    end
end