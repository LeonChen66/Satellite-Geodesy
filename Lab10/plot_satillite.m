loc = find(strcmp(test, 'G05'));
[row col] = ind2sub(size(test),loc);
col = col + 1;
G05 = {};
temp = 1;
for i = 1:length(row)
    G05(row(i),1) = test(row(temp),col(temp));
    temp = temp + 1;
end
id = cellfun(@isempty,G05);
G05(id) = {'0'};
G05 = cell2mat([cellfun(@str2num,G05(:,1),'un',0).']);
G05(G05 == 0) = NaN;

loc = find(strcmp(test, 'G20'));
[row col] = ind2sub(size(test),loc);
col = col + 1;
G20 = {};
temp = 1;
for i = 1:length(row)
    G20(row(i),1) = test(row(temp),col(temp));
    temp = temp + 1;
end
id = cellfun(@isempty,G20);
G20(id) = {'0'};
G20 = cell2mat([cellfun(@str2num,G20(:,1),'un',0).']);
G20(G20 == 0) = NaN;

loc = find(strcmp(test, 'G02'));
[row col] = ind2sub(size(test),loc);
col = col + 1;
G02 = {};
temp = 1;
for i = 1:length(row)
    G02(row(i),1) = test(row(temp),col(temp));
    temp = temp + 1;
end
id = cellfun(@isempty,G02);
G02(id) = {'0'};
G02 = cell2mat([cellfun(@str2num,G02(:,1),'un',0).']);
G02(G02 == 0) = NaN;

loc = find(strcmp(test, 'G19'));
[row col] = ind2sub(size(test),loc);
col = col + 1;
G19 = {};
temp = 1;
for i = 1:length(row)
    G19(row(i),1) = test(row(temp),col(temp));
    temp = temp + 1;
end
id = cellfun(@isempty,G19);
G19(id) = {'0'};
G19 = cell2mat([cellfun(@str2num,G19(:,1),'un',0).']);
G19(G19 == 0) = NaN;

loc = find(strcmp(test, 'G25'));
[row col] = ind2sub(size(test),loc);
col = col + 1;
G25 = {};
temp = 1;
for i = 1:length(row)
    G25(row(i),1) = test(row(temp),col(temp));
    temp = temp + 1;
end
id = cellfun(@isempty,G25);
G25(id) = {'0'};
G25 = cell2mat([cellfun(@str2num,G25(:,1),'un',0).']);
G25(G25 == 0) = NaN;

loc = find(strcmp(test, 'G23'));
[row col] = ind2sub(size(test),loc);
col = col + 1;
G23 = {};
temp = 1;
for i = 1:length(row)
    G23(row(i),1) = test(row(temp),col(temp));
    temp = temp + 1;
end
id = cellfun(@isempty,G23);
G23(id) = {'0'};
G23 = cell2mat([cellfun(@str2num,G23(:,1),'un',0).']);
G23(G23 == 0) = NaN;

loc = find(strcmp(test, 'G09'));
[row col] = ind2sub(size(test),loc);
col = col + 1;
G09 = {};
temp = 1;
for i = 1:length(row)
    G09(row(i),1) = test(row(temp),col(temp));
    temp = temp + 1;
end
id = cellfun(@isempty,G09);
G09(id) = {'0'};
G09 = cell2mat([cellfun(@str2num,G09(:,1),'un',0).']);
G09(G09 == 0) = NaN;

loc = find(strcmp(test, 'G17'));
[row col] = ind2sub(size(test),loc);
col = col + 1;
G17 = {};
temp = 1;
for i = 1:length(row)
    G17(row(i),1) = test(row(temp),col(temp));
    temp = temp + 1;
end
id = cellfun(@isempty,G17);
G17(id) = {'0'};
G17 = cell2mat([cellfun(@str2num,G17(:,1),'un',0).']);
G17(G17 == 0) = NaN;

loc = find(strcmp(test, 'G24'));
[row col] = ind2sub(size(test),loc);
col = col + 1;
G24 = {};
temp = 1;
for i = 1:length(row)
    G24(row(i),1) = test(row(temp),col(temp));
    temp = temp + 1;
end
id = cellfun(@isempty,G24);
G24(id) = {'0'};
G24 = cell2mat([cellfun(@str2num,G24(:,1),'un',0).']);
G24(G24 == 0) = NaN;

loc = find(strcmp(test, 'G06'));
[row col] = ind2sub(size(test),loc);
col = col + 1;
G06 = {};
temp = 1;
for i = 1:length(row)
    G06(row(i),1) = test(row(temp),col(temp));
    temp = temp + 1;
end
id = cellfun(@isempty,G06);
G06(id) = {'0'};
G06 = cell2mat([cellfun(@str2num,G06(:,1),'un',0).']);
G06(G06 == 0) = NaN;    

loc = find(strcmp(test, 'G29'));
[row col] = ind2sub(size(test),loc);
col = col + 1;
G29 = {};
temp = 1;
for i = 1:length(row)
    G29(row(i),1) = test(row(temp),col(temp));
    temp = temp + 1;
end
id = cellfun(@isempty,G29);
G29(id) = {'0'};
G29 = cell2mat([cellfun(@str2num,G29(:,1),'un',0).']);
G29(G29 == 0) = NaN;   

plot(G24,'k*-');
title('Satellite G24');
xlim([0 120])
xlabel('Every 30 sec in an hour');
ylabel('C/A code range(m)');