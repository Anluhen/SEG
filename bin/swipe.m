function F = swipe(bloco)

flag = 0;           %Flag do fim da varredura
while flag == 0     %Loop de varredura e conexão
    flag = 1;
    for i = 1:length(bloco)
        for j = 1:length(bloco)
            if bloco{i}.tipo ~= "Output" && bloco{j}.tipo ~= "Input"                          %Conecta os blocos e atualiza as saídas
                
                if ~isempty(bloco{i}.valorSaida)
                    if isempty(bloco{j}.inConnection) || ~any(bloco{j}.inConnection == bloco{i}.nome)
                        for k = 1:length(bloco{i}.outConnection)
                            if bloco{i}.outConnection(k) == bloco{j}.nome
                                bloco{j}.valorEntrada = [bloco{j}.valorEntrada, bloco{i}.valorSaida];                                %Passa o valor de um bloco pro outro
                                bloco{j}.inConnection = [bloco{j}.inConnection, bloco{i}.nome];                                      %Passa o nome do bloco conectado
                                if ismethod(bloco{j},'update')
                                    update(bloco{j});                                            %Atualiza a saida do bloco que recebeu a entrada
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    for k = 1:size(bloco,2)     %Checagem de fim de varredura
        if ~any(bloco{k}.tipo == "Output")   %Verifica se todos os blocos receberam a entrada
            if isempty(bloco{k}.valorSaida)
                flag = 0;
            end
        end
    end
end

F = bloco;

end