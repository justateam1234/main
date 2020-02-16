% clear
% % read();
% year_model_and_(10)

% t_s=19723;t_e=80353;
%     t_s=1800+t_s/365.25;t_e=1800+t_e/365.25;
%     t_after=50;%after that years
%     t_p=t_e+t_after;
%     t=linspace(t_s,t_e,length(T));
% % figure
% plot(t,T,'-o');hold on;
% 
% data.t=t;
% data.T=T;
% save('D:\model\code_co\Lon_-8_Lat_58.mat','data')
function [dT,err]=year_model_and_predicate(Y_after)
    [t,T]=getT(2 ,56);
    [dT,err]=year_ava(t,T,Y_after);
end


function [dT,err]=year_ava(t,tempe_point,Y_after)
    t(end)=[];tempe_point(end)=[];%abroad the last data
    tempe_point=reshape(tempe_point,12,length(tempe_point)/12);
    tempe_point=mean(tempe_point,1);
    size(tempe_point);
    
    t_s=19723;t_e=80353;
    t_s=1800+t_s/365.25;t_e=1800+t_e/365.25;
    t_after=Y_after;%after that years,
    t_p=t_e+t_after;
    t=linspace(t_s,t_e,length(tempe_point));
    t_pre=linspace(t_s,t_p,length(tempe_point)+t_after);
    
% %%%%%%%%%%%%%%%%%%damping model    
%     fun=@(pa,t)pa(1)*sin( pa(2)*(t-pa(3)) +pa(4) )+pa(5)*(t-pa(3))+pa(6);pa0=[1,5e-1,1840,1,0.01,10];
%     pa=lsqcurvefit(fun,pa0,t,tempe_point)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%logis model   
%     fun=@(pa,t)pa(1)./(1+(pa(1)/pa(2)-1)*exp(-pa(3)*(t-pa(4))));pa0=[10,tempe_point(1),0.01,1840];
%     pa=lsqcurvefit(fun,pa0,t,tempe_point,[],[15,15,1,2000])
%%%%%%%%%%%%%%%%%%%%%%%quadratic model
%     fun=@(pa,t)pa(1)*t.^2+pa(2)*t+pa(3);pa0=[0.0001,1,0.9];
%     pa=lsqcurvefit(fun,pa0,t,tempe_point);
%%%%%%%%%%%%%%%%%%%%%%%linear model
    fun=@(pa,t)pa(2)*t+pa(3);pa0=[0,001,9];
    pa=lsqcurvefit(fun,pa0,t,tempe_point);
    
    tempe_fit=fun(pa,t);
    tempe_pre=fun(pa,t_pre);
    
    err=sqrt(mean((tempe_fit-tempe_point).^2));
     
%     figure
%         plot(t,tempe_point,'-o');hold on;
%         plot(t,tempe_fit);hold on;
%         plot(t_pre,tempe_pre);hold on;

%         plot(t_pre,tempe_pre+err);hold on;
%         plot(t_pre,tempe_pre-err);hold on;
%         title('year_ava')
    T_after=tempe_pre(end);
    [~,start_in]=min(abs(t-1995));%data from 1995 
    T_now=tempe_point(start_in);
    dT=T_after-T_now;
   
end

function season_ava(t,tempe_point)
    t(end)=[];tempe_point(end)=[];%abroad the last data
    tempe_point=reshape(tempe_point,3,length(tempe_point)/3);
    tempe_point=mean(tempe_point,1);
    size(tempe_point);
    
    t_s=19723;t_e=80353;
    t_s=1800+t_s/365.25;t_e=1800+t_e/365.25;
    t=linspace(t_s,t_e,length(tempe_point)/4);
    index=[1:1:length(t)]*4-3;
    T1=tempe_point(index);
    T2=tempe_point(index+1);
    T3=tempe_point(index+2);
    T4=tempe_point(index+3);
    size(t)
    size(T1)
    figure
        plot(t,T1);hold on;plot(t,T2);hold on;plot(t,T3);hold on;plot(t,T4);hold on;
        legend('1-3','4-6','7-9','9-12')
    
end
function [t,tempe_point]=getT(Lo,La)
    [Lon,Lat,time,tempe]=read_long();
    [~,x]=min(abs(Lon-Lo));
    [~,y]=min(abs(Lat-La));%返回某个点的索引

    tempe_point=(tempe(x,y,:));
    size(tempe_point);
    % temp_point=temp_point(find(temp_point~=-2));

    tempe_point=squeeze(tempe_point);
    t=time;
    
%     figure
%     plot(t,tempe_point,'-o')
end
function [x,y,time,tempe]=read_long()
    filename='D:\model\A_data\sst.mnmean_errst_v5.nc';
%     ncdisp(filename)
    Lon_start_in=175;%4     
    Lon_len=15;
    Lat_start_in=11;%56
    Lat_len=10;
    Lon=ncread(filename,'lon');Lon=[Lon;Lon+360];
    Lat=ncread(filename,'lat');%Lat=[Lat;Lat];
    time=ncread(filename,'time');
    x=Lon(Lon_start_in:Lon_start_in+Lon_len-1)-360;
    y=Lat(Lat_start_in:Lat_start_in+Lat_len-1);%68-52
    
    ncid=netcdf.open(filename,'NOWRITE');
    winddata = netcdf.getVar(ncid,4); 
    netcdf.close(ncid);
    
    size(winddata);
    
    datamin=min(min(min(winddata)));
    a=(find(winddata==datamin));
    winddata(a)=0;
    class(a);
    datamin=min(min(min(winddata)));
%     imagesc(winddata(:,:,end));colorbar;
    
    tempe=zeros(Lon_len,Lat_len,length(time));
    tempe(1:180-Lon_start_in+1,:,:)=winddata(Lon_start_in:end,...
         Lat_start_in: Lat_start_in+Lat_len-1,:);
    tempe(180-Lon_start_in+2:end,:,:)=winddata(1:Lon_len-(180-Lon_start_in)-1,...
         Lat_start_in: Lat_start_in+Lat_len-1,:);
%     figure
%         imagesc(transpose(tempe(:,:,end)));
end

% function [x,y,time,tempe]=read()
%     filename='D:\model\A_data\sst.mnmean_errst_v5.nc';
% %     ncdisp(filename)
%     Lon_start_in=175;%4     
%     Lon_len=15;
%     Lat_start_in=11;%56
%     Lat_len=10;
%     Lon=ncread(filename,'lon');Lon=[Lon;Lon+360];
%     Lat=ncread(filename,'lat');%Lat=[Lat;Lat];
%     time=ncread(filename,'time');
%     x=Lon(Lon_start_in:Lon_start_in+Lon_len-1)-360;
%     y=Lat(Lat_start_in:Lat_start_in+Lat_len-1);%68-52
%     
%     ncid=netcdf.open(filename,'NOWRITE');
%     winddata = netcdf.getVar(ncid,4); 
%     netcdf.close(ncid);
%     
%     size(winddata);
%     
%     datamin=min(min(min(winddata)));
%     a=(find(winddata==datamin));
%     winddata(a)=0;
%     class(a);
%     datamin=min(min(min(winddata)));
% %     imagesc(winddata(:,:,end));colorbar;
%     
%     tempe=zeros(Lon_len,Lat_len,length(time));
%     tempe(1:180-Lon_start_in+1,:,:)=winddata(Lon_start_in:end,...
%          Lat_start_in: Lat_start_in+Lat_len-1,:);
%     tempe(180-Lon_start_in+2:end,:,:)=winddata(1:Lon_len-(180-Lon_start_in)-1,...
%          Lat_start_in: Lat_start_in+Lat_len-1,:);
%     figure
%         imagesc([x(1),x(end)],[y(1),y(end)],transpose(tempe(:,:,end)));
%         set(gca,'YDir','normal')
% end