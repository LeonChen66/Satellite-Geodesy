fid = fopen('igu19416_18.sp3');
pattern = 'PG15';
i = 1;
test = {};
while feof(fid) ==0
    line = fgetl(fid);
    matched = findstr(line,pattern)
    line = strsplit(line);
    test(end+1,1:length(line)) = line;
    i = i+1;
end

PG15 = {}
j = 1;
for i = 1:length(test)
    if strcmp(test(i,1),'PG15')==1
        PG15(j,:) = test(i,:);
        j = j+1;
    end
end

XYZ = PG15(:,2:4);
data=cellfun(@str2num,XYZ); 