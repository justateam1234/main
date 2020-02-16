clear
%lat:1deg~=111km;lat:
[Lon,Lat,time,T]=read();
T=mean(T,3);
% findfish(Lon,Lat,T,10,0.1);
earn(Lon,Lat,T)
function earn(Lon,Lat,T)
    x=linspace(0,dLon_to_km(Lon(1),Lon(end),mean(Lat)),length(Lon));
    y=linspace(0,(Lat(1)-Lat(end))*6371*pi/360,length(Lat));y=fliplr(y);
    [xx,yy]=meshgrid(x,y)
    xx=transpose(xx);
    yy=transpose(yy);
    peterhead=[-1.785429,57.499584];%biggist%%%%%%%%%%%%%%%%change port
    scraber=[-3.544892;58.608053] ;peterhead=scraber;
    x_port=(peterhead(1)-Lon(1))./(Lon(end)-Lon(1))*(x(end)-x(1))
    y_port=(peterhead(2)-Lat(end))./(Lat(1)-Lat(end))*(y(1)-y(end))
%     xp=(Lonp-Lon(1))./(Lon(end)-Lon(1))*(x(end)-x(1));
%     yp=(Latp-Lat(end))./(Lat(1)-Lat(end))*(y(1)-y(end));
    
    pa_herr=[3.734*1e4,9.853,1.511];%herringˆÓ”„
    pa_hack=[3.766*1e4,10,1.64];%mackerelˆÎ”„
    fishtype=1;%%%%%%%%%%%%%%%%%%%%%%%choose fish
    distent_cost=640*2/54;
    fish_prize=[463/2,880.8/2];
    pa(1,:)=pa_herr;pa(2,:)=pa_hack;
    
    den=@(pa,T)pa(1)*exp(-  ((T-pa(2))/pa(3)).^2);
    disten=@(X,Y)sqrt((X-x_port).^2+(Y-y_port).^2);
    
    land_in=find(T<1)%%%%%%%%%%%%%%%%the land's index
    min(min(T))
    
    den_distribu=den(pa(fishtype,:),T);%the density function
%     den_distribu(find(den_distribu<0))=0;
%     den_distribu(land_in)=100;%set a value which can show the land in the data
    
    disten_distribu=disten(xx,yy);
    disten_distribu(land_in)=0;
    
    
    figure
        imagesc([x(1),x(end)],[y(1),y(end)],transpose(T(:,:)));colorbar;hold on;
        scatter(x_port,y_port,100);hold on;
%         scatter(xp,yp,100);hold on;
        set(gca,'YDir','normal')
   figure
        imagesc([x(1),x(end)],[y(1),y(end)],transpose(disten_distribu(:,:)));colorbar;hold on;
        scatter(x_port,y_port,100);hold on;
        title('dis')
        set(gca,'YDir','normal')     
   
    
    figure
        imagesc([x(1),x(end)],[y(1),y(end)],transpose(den_distribu(:,:)));colorbar;hold on;
        scatter(x_port,y_port,100);hold on;
        title('den')
        set(gca,'YDir','normal')
    
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