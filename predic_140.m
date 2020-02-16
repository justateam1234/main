read()
function [x,y,time,T]=read();
%     filename='D:\model\A_data\sst.day.1981-2010.ltm.nc';
    filename='D:\model\A_data\NOAAGlobalTemp_v5.0.0_gridded_s188001_e202001_c20200206T133319.nc';
    ncdisp(filename)
    Lon_start_in=1;%,2.5     
    Lat_start_in=30;%57  7--57d

    Lon=ncread(filename,'lon');Lon=[Lon;Lon+360];
    Lat=ncread(filename,'lat');%Lat=[Lat;Lat];
    time=ncread(filename,'time');
%     x=Lon(Lon_start_in:Lon_start_in+Lon_len-1)-360;
%     y=Lat(Lat_start_in:Lat_start_in+Lat_len-1);y=fliplr(y);
  
    ncid=netcdf.open(filename,'NOWRITE');
    winddata = netcdf.getVar(ncid,4);
    netcdf.close(ncid);
    
    size(winddata)
    return
    thr=min(min(min(min(winddata))))
    winddata(find(winddata==thr))=-0;
   
    
    datamax=double(max(max(max(max(winddata)))))
    datamin=double(min(min(min(min(winddata)))))
    
    
 
   
    figure
        imagesc(transpose(winddata(:,:,1,end-5)));colorbar;
    ac_max=40;ac_min=-40;
    T=winddata(Lon_start_in,Lat_start_in,1,:);
    T=(T-datamin)./(datamax-datamin) * (ac_max-ac_min)+ac_min;
%     T=T*2;
    T=squeeze(T);
    
    T(end)=[];time(end)=[];
    
        
    T_yava=reshape(T,140,12);time_yava=1880:2019;   
   
    T_yava=mean(T_yava,2);
   
    time(find(T==-40))=[];T(find(T==-40))=[];
    
    figure
        plot(time,T);hold on;
        title('monthly')
    figure
         size(T_yava)
         size(time_yava)
        plot(time_yava,T_yava)
    return
    tempe=zeros(Lon_len,Lat_len,length(time));
    tempe(1:360-Lon_start_in+1,:,:)=winddata(Lon_start_in:end,...
         Lat_start_in: Lat_start_in+Lat_len-1,:);
    tempe(360-Lon_start_in+2:end,:,:)=winddata(1:Lon_len-(360-Lon_start_in)-1,...
         Lat_start_in: Lat_start_in+Lat_len-1,:);
%    
     
     tempe(find(tempe==32767))=-2;
     ac_max=33.6178;ac_min=-1.80017;
%      tempe=(tempe-min(tempe))./(max(tempe)-min(tempe)) * (ac_max-ac_min)+ac_min;
%      tempe=flipud(tempe);
    
%     figure
%         winddata(find(winddata==32767))=-2;
% %         winddata=(winddata-min(winddata))./(max(winddata)-min(winddata)) * (ac_max-ac_min)+ac_min;
%         
%         imagesc(transpose(winddata(:,:,1)));colorbar;

%      figure
%      for a=1:1
% %          imagesc(transpose(tempe(:,:,a)));colorbar;
%          imagesc([x(1),x(end)],[y(1),y(end)],transpose(tempe(:,:,a)));colorbar;
%          pause(0.01)
%          title(num2str(a));
%          set(gca,'YDir','normal')
% %          
%      end
     
     
end