function checkEpipolarLine(F, num, Ileft, Iright, axesL, axesR)

%% Select three points in the first image
% figure;
% subplot(121), imshow(Ileft), title('select three points');
% hold on

xline = ginput(num)';
hold on;
plot(axesL, xline(1,:), xline(2,:), 'b*', 'MarkerSize', 15);
xline(3,:) = ones(1,num);

%% Display the corresponding line in the other image
% subplot(122), imshow(Iright), title('epipolar line');
for i=1:num
    l1(:,i) = F'*xline(:,i);
end

for i=1:num
    x=1:size(Ileft,2);
    y=(-l1(1,i)*x-l1(3,i))/l1(2,i);
    plot(axesR, x, y, '.g');
    hold on;
end