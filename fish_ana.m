

[Lon,Lat,time,tempe]=read();
tempe=mean(tempe,3);
x=Lon;y=Lat;
T_cen=9.8;
T_dis=0.3;
% predicfish_dis(Lon,Lat,time,tempe,T_cen,T_dis)
fish_move_path(Lon,Lat,time,tempe,T_cen,T_dis)
function predicfish_dis(Lon,Lat,time,tempe_start,T_cen,T_dis)

    Y_after_list=[0,10,25,50];
    for a=1:length(Y_after_list)
        Y_after=Y_after_list(a);
        [dT,err]=year_model_and_predicate(Y_after);
        findfish_max(Lon,Lat,tempe_start+dT,T_cen,T_dis,Y_after);
%         findfish_area(Lon,Lat,tempe+dT,T_cen,T_dis,Y_after);
    end
end

function fish_move_path(Lon,Lat,time,tempe_start,T_cen,T_dis)
    peterhead=[-1.785429,57.499584];%biggist
    scraber=[-3.544892;58.608053] ;peterhead=scraber;
    x_port=peterhead(1);y_port=peterhead(2);
    
    
    
        
    x=[];y=[];
    for Y_after=0:10:50
        [dT,err]=year_model_and_predicate(Y_after);
        [a,b]=findfish_max(Lon,Lat,tempe_start+dT,T_cen,T_dis,Y_after)
        x=[x,a];y=[y,b];
    end 
    figure
%     imagesc([Lon(1),Lon(end)],[Lat(1),Lat(end)],transpose(T(:,:)));colorbar;hold on;
    imagesc([Lon(1),Lon(end)],[Lat(1),Lat(end)],transpose(tempe_start(:,:)));colorbar;hold on;
    scatter(x_port,y_port,100,'b','filled');hold on;
%     scatter(500,400,100);hold on;
%     scatter(x,y,'r','filled');hold on;
    quiver(x(1:end-1),y(1:end-1),x(2:end)-x(1:end-1),y(2:end)-y(1:end-1),0,'b');
%%%%%%%%%%%%%%%%%%%%%%%%%%%use when many point
%     colorlist={'r','b','k'};colorlist{mod(a+2,3)+1};
    for a=1:length(x)
%         quiver(x(a),y(a),x(a+1)-x(a),y(a+1)-y(a),0);hold on;
        scatter(x(a),y(a),'filled');hold on;
    end
    LL=legend('port','path','after 0 years','after 10 years','after 20 years','after 30 years',...
        'after 40 years','after 50 years','Location','southeast');
    set(LL,'Fontsize',10);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    set(gca,'YDir','normal')
    xlabel('Lon/бу');ylabel('Lat/бу')
end
function fishhere=findfish_area(Lon,Lat,T,T_cen,T_dis,Y_after)
    
    peterhead=[-1.785429,57.499584];%biggist
    scraber=[-3.544892;58.608053] ;peterhead=scraber;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Lon,Lat
    x=Lon;y=Lat;
    x_port=peterhead(1);y_port=peterhead(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Km
%     x=linspace(0,dLon_to_km(Lon(1),Lon(end),mean(Lat)),length(Lon));
%     y=linspace(0,(Lat(1)-Lat(end))*6371*pi/360,length(Lat));y=fliplr(y);
%     x_port=(peterhead(1)-Lon(1))./(Lon(end)-Lon(1))*(x(end)-x(1))
%     y_port=(peterhead(2)-Lat(end))./(Lat(1)-Lat(end))*(y(1)-y(end))
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    
    [xx,yy]=meshgrid(x,y);
    xx=transpose(xx);
    yy=transpose(yy);
    size(xx);
    size(T);
   
    fish_in=find(abs(T-T_cen)<=T_dis);
 figure
%     imagesc([Lon(1),Lon(end)],[Lat(1),Lat(end)],transpose(T(:,:)));colorbar;hold on;
    imagesc([x(1),x(end)],[y(1),y(end)],transpose(T(:,:)));colorbar;hold on;
    scatter(x_port,y_port,100,'b','filled');hold on;
%     scatter(500,400,100);hold on;
    scatter(xx(fish_in),yy(fish_in),'r','filled');
    set(gca,'YDir','normal')
    xlabel('Lon/бу');ylabel('Lat/бу')
%     title('fish')
    
    LL=legend('harber','fish accumulation area','Location','southeast')
    set(LL,'Fontsize',15);
    
    set(gcf,'Units','Inches');
    pos = get(gcf,'Position');
    set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
%     saveas(gcf,['D:\model\code_co\main\code\tex\image\fish_area_after'...
%         num2str(Y_after),'years.eps'],'psc2')
    
    fishhere=zeros(size(T));
    fishhere(fish_in)=1;
% figure
%     imagesc(transpose(fishhere))
    
end
function [X,Y]=findfish_max(Lon,Lat,T,T_cen,T_dis,Y_after)
    
    peterhead=[-1.785429,57.499584];%biggist
    scraber=[-3.544892;58.608053] ;peterhead=scraber;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Lon,Lat
    x=Lon;y=Lat;
    x_port=peterhead(1);y_port=peterhead(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Km
%     x=linspace(0,dLon_to_km(Lon(1),Lon(end),mean(Lat)),length(Lon));
%     y=linspace(0,(Lat(1)-Lat(end))*6371*pi/360,length(Lat));y=fliplr(y);
%     x_port=(peterhead(1)-Lon(1))./(Lon(end)-Lon(1))*(x(end)-x(1))
%     y_port=(peterhead(2)-Lat(end))./(Lat(1)-Lat(end))*(y(1)-y(end))
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    
    [xx,yy]=meshgrid(x,y);
    xx=transpose(xx);
    yy=transpose(yy);
   
    dT=abs(T-T_cen);
    dT=dT(:);
    [dT_min,fish_in]=min(dT)
  
    X=xx(fish_in);
    Y=yy(fish_in);
 
  return 
 figure
%     imagesc([Lon(1),Lon(end)],[Lat(1),Lat(end)],transpose(T(:,:)));colorbar;hold on;
    imagesc([x(1),x(end)],[y(1),y(end)],transpose(T(:,:)));colorbar;hold on;
    scatter(x_port,y_port,100,'b','filled');hold on;
%     scatter(500,400,100);hold on;
    scatter(xx(fish_in),yy(fish_in),'r','filled');hold on;
    set(gca,'YDir','normal')
    xlabel('Lon/бу');ylabel('Lat/бу')
%     title('fish')
    LL=legend('harber','fish accumulation area','Location','southeast');
    set(LL,'Fontsize',15);
    
    set(gcf,'Units','Inches');
    pos = get(gcf,'Position');
    set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);  
%     saveas(gcf,['D:\model\code_co\main\code\tex\image\fish_max_point_after'...
%         num2str(Y_after),'years.eps'],'psc2')
    
%     fishhere=zeros(size(T));
%     fishhere(fish_in)=1;
% figure
%     imagesc((fishhere))
    
end


function dis=dLon_to_km(Lon1,Lon2,Lat)
%        dLon_to_km(1,0,50)
%        dLon_to_km(1,0,55)
       R=6371;%km
       dLon=abs(Lon1-Lon2);
       r=R*sind(Lat);
       dis=r*dLon/180*pi;
        
  end