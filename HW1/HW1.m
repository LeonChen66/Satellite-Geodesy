plot(test(:,1),test(:,5),'o');
hold on;
plot(test(:,1),test(:,6),'*');


title('Relationship between n and fn/一組可以互相觀測');
xlabel('Number of points');
ylabel('Degree of freedom');

legend('Relative','Absolute')