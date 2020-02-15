clear
% [t1,T1]=getT(7,64);
% [t2,T2]=getT(-7,58);
% figure
%     plot(t1,T1,'-o');hold on;
%     plot(t2,T2)
% read();
% ava()
month_correct()
function month_correct()
    [Lon,Lat,time,tempe]=read();
%     size(tempe)
    t=1:365;
    T_d_ava=size(t);
    figure
    imagesc(transpose(tempe(:,:,1)));colorbar
    for in=1:length(t)
        TT=tempe(:,:,in);
        TT=TT(:);
        T_d_ava(in)=mean(TT(find(TT>1)));
    end
    figure
    plot(t,T_d_ava)
    
     pa0=[3,-0.02,1.8,0.4];
     
    T_year_ava=mean(T_d_ava)
    fun=@(pa,t)pa(1)*sin(pa(2)*t+pi*pa(3))+pa(4)+T_year_ava;%注意相位加了pi
    pa=lsqcurvefit(fun,pa0,t,T_d_ava)
    T_d_fit=fun(pa,t);
    figure
    plot(t,T_d_ava,'-o');hold on;
    plot(t,T_d_fit);hold on;
end
function ava()
    [Lon,Lat,time,tempe]=read();
    x=Lon;y=Lat;
    tempe_ava=mean(tempe,3);%get the year avarage
    %save
    data=struct;
    data.temperature=tempe_ava;
    data.Lon=Lon;data.Lat=Lat;
    save('D:\model\A_data\data.mat','data')
    return
    size(tempe_ava)
    figure
        imagesc([x(1),x(end)],[y(1),y(end)],transpose(tempe_ava));colorbar;
%         imagesc(transpose(tempe_ava));colorbar;
        title('year ava');
        set(gca,'YDir','normal')
        [y(end),y(1)]
    
    len=length(x)*length(y);
    [xx,yy]=meshgrid(x,y);
    xx=transpose(xx);
    yy=transpose(yy);
    
    x=xx(:);y=yy(:);tempe_ava=tempe_ava(:);
    size(x)
    size(tempe_ava)
    
    
   use_index=[];
    tempe_to_fit=tempe_ava;%used to fit
    for in=1:len
        
        if tempe_to_fit(in)<=1%relete to the value represent the land.
            tempe_to_fit(in)=-99;x(in)=-99;y(in)=-99;
            temp_ava=0;%set the land to zero
        else
            use_index=[use_index,in];
        end
    end
    
    tempe_to_fit(find(tempe_to_fit==-99))=[];x(find(x==-99))=[];y(find(y==-99))=[];
%     figure
%         scatter(x,tempe_to_fit);
%     figure
%         scatter(y,tempe_to_fit);
        
    
    r=[x,y];
    pa0=[1,1,1,50,1];
    r=double(r);
    class(tempe_ava)
    fun=@(pa,r)pa(1)*(r(:,1)-pa(2)).^2+pa(3)*(r(:,2)-pa(4)).^2+pa(5);
    pa=lsqcurvefit(fun,pa0,r,tempe_to_fit)
   
    tempe_fit_1=fun(pa,r);
    tempe_fit=zeros(size(tempe_ava));
%     size(tempe_fit_1)
%     length(use_index)
    tempe_fit(use_index)=tempe_fit_1;
    tempe_fit=reshape(tempe_fit,length(Lon),length(Lat));
    tempe_ava=reshape(tempe_ava,length(Lon),length(Lat));
    
    figure
    imagesc(transpose(tempe_fit));colorbar;
    title(['fit:',num2str(pa(1)),'(Lon-',num2str(pa(2)),')^2+',...
        num2str(pa(3)),'(Lat-',num2str(pa(4)),')^2+',num2str(pa(5))]);
    
    
    
    err=abs(tempe_fit-tempe_ava)./abs(tempe_fit);
    figure
    imagesc(transpose(err));colorbar;
    title('relative err');
end






function [x,y,time,tempe]=read();
    filename='D:\model\A_data\sst.day.1981-2010.ltm.nc';
%     filename='D:\model\A_data\NOAAGlobalTemp_v5.0.0_gridded_s188001_e202001_c20200206T133319';
    
    Lon_start_in=345;%,347.5=-12.5 
    Lon_len=30;
    Lat_start_in=25;%50.5
    Lat_len=20;
    Lon=ncread(filename,'lon');Lon=[Lon;Lon+360];
    Lat=ncread(filename,'lat');%Lat=[Lat;Lat];
    time=ncread(filename,'time');
    x=Lon(Lon_start_in:Lon_start_in+Lon_len-1)-360;
    y=Lat(Lat_start_in:Lat_start_in+Lat_len-1);y=fliplr(y);
  
    ncid=netcdf.open(filename,'NOWRITE');
    winddata = netcdf.getVar(ncid,3);
    netcdf.close(ncid);
    size(winddata)
    
    winddata(find(winddata==32767))=0;
    datamax=double(max(max(max(max(winddata)))))
    datamin=double(min(min(min(min(winddata)))))
   
    ac_max=33.6178;ac_min=-1.80017;
%     winddata=(winddata-datamin)./(datamax-datamin)*(ac_max-ac_min)+ac_min;
    
    tempe=zeros(Lon_len,Lat_len,length(time));
    tempe(1:360-Lon_start_in+1,:,:)=winddata(Lon_start_in:end,...
         Lat_start_in: Lat_start_in+Lat_len-1,:);
    tempe(360-Lon_start_in+2:end,:,:)=winddata(1:Lon_len-(360-Lon_start_in)-1,...
         Lat_start_in: Lat_start_in+Lat_len-1,:);
%    
     
%      tempe(find(tempe==32767))=-2;
     
     class(tempe)
%      tempe=(tempe-min(tempe))./(max(tempe)-min(tempe)) * (ac_max-ac_min)+ac_min;
     tempe=(tempe-datamin)/(datamax-datamin) * (ac_max-ac_min)+ac_min;
%      tempe=flipud(tempe);
    
%     figure
% %         winddata(find(winddata==32767))=-2;
% %         winddata=(winddata-min(winddata))./(max(winddata)-min(winddata)) * (ac_max-ac_min)+ac_min;
%         
%         imagesc(transpose(winddata(:,:,1)));colorbar;

     figure
     for a=1:1
%          imagesc(transpose(tempe(:,:,a)));colorbar;
         imagesc([x(1),x(end)],[y(1),y(end)],transpose(tempe(:,:,a)));colorbar;
         pause(0.01)
         title(num2str(a));
         set(gca,'YDir','normal')
%          
     end
     
     
end