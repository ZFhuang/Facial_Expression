function linePointMatrix(inputs)
    hold on;
    plot(inputs(:,1),inputs(:,2),'white-');
    line([inputs(1,1),inputs(end,1)],[inputs(1,2),inputs(end,2)],'color','white');
    %line the start point to the end
    hold off;
end