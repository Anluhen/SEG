function C = infoReader(Diagrama)

fileID = fopen(Diagrama);
C = [];

while true
    line = fgetl(fileID);
    line = line(1:end-1);
    if ~isempty(line)
        A = textscan(line,'%s','Delimiter',',','CommentStyle','##','MultipleDelimsAsOne',1,'TextType','string');
        if ~isempty(A{1})
            C = [C, A];
        end
    elseif ~ischar(line)
        break
    end
end

fclose('all');

end