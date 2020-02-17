clear
%lat:1deg~=111km;lat:
[Lon,Lat,time,T]=read();
T=mean(T,3);

sensi(Lon,Lat,T);
% dTlist=[];
% for Y_after=0:50
%     [dT,err]=year_model_and_predicate(Y_after);
%     dTlist=[dTlist,dT];
% end
% dTlist
function sensi(Lon,Lat,T)
    pa1=1000;
    pa2=1300;
    pa3=35000;
    [time,prot,dis2,propa]=over_time(Lon,Lat,T,'',pa1,pa2,pa3);
    change=[0.8,0.9,1,1.1,1.2];
    figure
        for ch=1:5
            [time,prot,dis2,propa]=over_time(Lon,Lat,T,'',pa1,change(ch)*pa2,pa3);
%             plot(time,prot);hold on;
            plot(dis2,propa);hold on;
        end
%         xlabel('time/year');ylabel('profit/pound');
        xlabel('distance/km');ylabel('profit/pound');
        LL=legend('80%','90%','100%','110%','120%');set(LL,'Fontsize',15);
        grid on;
end
function [time,pro,dis2,profit]=over_time(Lon,Lat,T,modeltype,pa1,pa2,pa3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a=load('D:\model\A_data\dTlist_quadratic_model.mat');
dTlist=a.dTlist;dTlist(1)=[];
thr=100;%%%%%%%%%%%%%%%%%%%%%%%%%%%%ship range


pro=zeros(size(dTlist));
time=1:50;
[~,err]=year_model_and_predicate(50);
for in=1:length(dTlist)    
    [dis,pro_now]=earn(Lon,Lat,T+dTlist(in),time(in),'',pa1,pa2,pa3);
    [~,dis_in]=(min(abs(dis-thr)))
    dis(dis_in)
    pro(in)=max(pro_now(1:dis_in)); 
end

pro_in=find(pro<=0);

Y_after_list=[50];

    for a=1:length(Y_after_list)
        Y_after=Y_after_list(a);
        [dT,err]=year_model_and_predicate(Y_after);
        [dis2,profit]=earn(Lon,Lat,T+dT,Y_after_list(a),'',pa1,pa2,pa3);
%         plot(dis2,profit);hold on;
        grid on;
    end
    
end
function [distance_value,dis_max_netpro]=earn(Lon,Lat,T,Y_after,model_type,pa1,pa2,pa3)
    x=linspace(0,dLon_to_km(Lon(1),Lon(end),mean(Lat)),length(Lon));
    y=linspace(0,(Lat(1)-Lat(end))*6371*pi/360,length(Lat));y=fliplr(y);
    [xx,yy]=meshgrid(x,y);
    xx=transpose(xx);
    yy=transpose(yy);
    %biggist%%%%%%%%%%%%%%%%change port
   
    scraber=[-3.544892;58.608053] ;
%     changeport=[10.6,59.9];
    peterhead=scraber;
    x_port=(peterhead(1)-Lon(1))./(Lon(end)-Lon(1))*(x(end)-x(1));
    y_port=(peterhead(2)-Lat(end))./(Lat(1)-Lat(end))*(y(1)-y(end));
%     xp=(Lonp-Lon(1))./(Lon(end)-Lon(1))*(x(end)-x(1));
%     yp=(Latp-Lat(end))./(Lat(1)-Lat(end))*(y(1)-y(end));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%constant set
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pa_herr=[3.734*1e4,9.853,1.511];%herringöîÓã
    pa_hack=[3.766*1e4,10,1.64];%mackerelöëÓã
    
    distent_cost=pa1 *2/54;
    pa_profit=pa2;
    stable_cost=pa3;
    fish_prize=[463,880.8,(463+880.8)/2];
    pa(1,:)=pa_herr;pa(2,:)=pa_hack;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%constant set
    den=@(pa,T)pa(1)*exp(-  ((T-pa(2))/pa(3)).^2);
    disten=@(X,Y)sqrt((X-x_port).^2+(Y-y_port).^2);
    
    land_in=find(T<2) ;%%%%%%%%%%%%%%%%the land's index
    min(min(T));
    %the density function
    
    density_distribu1=den(pa(1,:),T);
    density_distribu2=den(pa(2,:),T);
    density_distribu1(land_in)=-1e3;%set a value which can show the land in the data  
    density_distribu2(land_in)=-1e3;

    %the distance distribution
    distance_distribu=disten(xx,yy);
    distance_distribu(land_in)=0;%set a value which can show the land in the data
    
    %caculate the net profit
    cost_distribu=distent_cost*distance_distribu;
    density_max1=max(max(density_distribu1));
    density_max2=max(max(density_distribu2));
    
    c1=density_distribu1./(density_distribu1+density_distribu2);
    c2=density_distribu2./(density_distribu1+density_distribu2);%note that c is matrix!!!
    profit_distribu=c1.*(fish_prize(1)).*density_distribu1/density_max1*pa_profit*0.1+...
    c2.*(fish_prize(2)).*density_distribu2/density_max2*pa_profit*0.1;
%     profit_distribu=(fish_prize(fishtype))*density_distribu/density_max*180;
    net_profit_distribu=profit_distribu-cost_distribu-stable_cost;
%     net_profit_distribu(land_in)=-1*min(min(net_profit_distribu))...
%         *sign(min(min(net_profit_distribu)))*2;%to show the land
    
    
    %caculate the max netprofit in a given distence
    distance_value=unique(distance_distribu(:));
    distance_value=linspace(min(distance_value),max(distance_value),50);
    distance_len=distance_value(2)-distance_value(1);
    distance_value(1)=[];%remove the data represent the port which is unrelated data
    dis_max_netpro=zeros(size(distance_value));
    
    for in=1:length(distance_value)
        current_dist_in=find(abs(distance_distribu-distance_value(in))<distance_len);
        current_max_pro=max(net_profit_distribu(current_dist_in));
        dis_max_netpro(in)=current_max_pro;
    end
    net_profit_distribu(land_in)=0;
    
%     figure
%         imagesc([x(1),x(end)],[y(1),y(end)],transpose(T(:,:)));colorbar;hold on;
%         scatter(x_port,y_port,100);hold on;
% %         scatter(xp,yp,100);hold on;
%         set(gca,'YDir','normal')
%    figure
%         imagesc([x(1),x(end)],[y(1),y(end)],transpose(distance_distribu(:,:)));colorbar;hold on;
%         scatter(x_port,y_port,100);hold on;
%         title('dis')
%         set(gca,'YDir','normal')     
%         xlabel('distance/km');ylabel('distance/km');
%     
%     figure
%         imagesc([x(1),x(end)],[y(1),y(end)],transpose(density_distribu1(:,:)));colorbar;hold on;
%         scatter(x_port,y_port,100);hold on;
%         title('den')
%         set(gca,'YDir','normal')
%         xlabel('distance/km');ylabel('distance/km');
% %         
%     figure
%         imagesc([x(1),x(end)],[y(1),y(end)],transpose(net_profit_distribu(:,:)));colorbar;hold on;
%         scatter(x_port,y_port,100,'b','filled');hold on;
%         
%         scatter(xx(land_in),yy(land_in),300,'s','MarkerEdgeColor',[.8 .8 .8],...
%               'MarkerFaceColor',[.8 .8 .8]);hold on;
%         LL=legend('harbor','land','Location','southeast');set(LL,'Fontsize',20);
% %         title(num2str(Y_after))
%        
%         xlabel('distance/km');ylabel('distance/km');
%         
%         set(gca,'YDir','normal')        
%         set(gcf,'Units','Inches');
%         pos = get(gcf,'Position');
%         set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
% %         saveas(gcf,['D:\model\code_co\main\code\tex\image\',...
% %             'profit_dis_after',model_type,num2str(Y_after),'image.eps'],'psc2')

%     figure
%         plot(distance_value,dis_max_netpro);
%         title('profit vs distance');
%         xlabel('distance/km');ylabel('net profit/pound');
%     
end
function fishhere=findfish(Lon,Lat,T,T_cen,T_dis)
    
    peterhead=[-1.785429,57.499584];%biggist
    scraber=[-3.544892;58.608053] ;peterhead=scraber;
%     x_port=dLon_to_km(peterhead(1),-12.5,peterhead(2))
%     y_port=abs(peterhead(2)-65.5)/180*pi*6371
%     
%     x=Lon;y=Lat;
    x=linspace(0,dLon_to_km(Lon(1),Lon(end),mean(Lat)),length(Lon));
    y=linspace(0,(Lat(1)-Lat(end))*6371*pi/360,length(Lat));y=fliplr(y);
    
    x_port=(peterhead(1)-Lon(1))./(Lon(end)-Lon(1))*(x(end)-x(1))
    y_port=(peterhead(2)-Lat(end))./(Lat(1)-Lat(end))*(y(1)-y(end))
    
    [xx,yy]=meshgrid(x,y)
    xx=transpose(xx);
    yy=transpose(yy);
    size(xx)
    size(T)
   
    fish_in=find(abs(T-T_cen)<=T_dis);
 figure
%     imagesc([Lon(1),Lon(end)],[Lat(1),Lat(end)],transpose(T(:,:)));colorbar;hold on;
    imagesc([x(1),x(end)],[y(1),y(end)],transpose(T(:,:)));colorbar;hold on;
    scatter(x_port,y_port,100);hold on;
%     scatter(500,400,100);hold on;
    scatter(xx(fish_in),yy(fish_in));
    set(gca,'YDir','normal')
    

    fishhere=zeros(size(T));
    fishhere(fish_in)=1;
figure
    imagesc(transpose(fishhere))
    
end
function dis=dLon_to_km(Lon1,Lon2,Lat)
%        dLon_to_km(1,0,50)
%        dLon_to_km(1,0,55)
       R=6371;%km
       dLon=abs(Lon1-Lon2);
       r=R*sind(Lat);
       dis=r*dLon/180*pi;
        
  end