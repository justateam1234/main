clear
% [t1,T1]=getT(7,64);
% [t2,T2]=getT(-7,58);
% figure
%     plot(t1,T1,'-o');hold on;
%     plot(t2,T2)
% read();
spatial_fit()
% month_correct()
% month_correct()
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
    grid on;xlabel('t/day');ylabel('T/degree');
    title([num2str(pa(1)),'sin(',num2str(pa(2)),'t+',num2str(pa(3)),')+',num2str(pa(4)),'+year avarage temperature'])
    
%     set(gca,'YDir','normal')
    set(gcf,'Units','Inches');
    pos = get(gcf,'Position');
    set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    saveas(gcf,'D:\model\code_co\main\code\tex\image\month_correct.eps','psc2')
    
end
function spatial_fit()
    [Lon,Lat,time,tempe]=read();
    x=Lon;y=Lat;
    
    tempe_ava=mean(tempe,3);%get the year avarage for a location
%     %%%%%%%%%%%%%%%%%%save
%     data=struct;
%     data.temperature=tempe_ava;
%     data.Lon=Lon;data.Lat=Lat;
% %     save('D:\model\A_data\data.mat','data')
%     return
    size(tempe_ava)
%     figure
%         imagesc([x(1),x(end)],[y(1),y(end)],transpose(tempe_ava));colorbar;
% %         imagesc(transpose(tempe_ava));colorbar;
%         title('year ava');
%         set(gca,'YDir','normal')
%         [y(end),y(1)]
    
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
%     fun=@(pa,r)pa(1)*(r(:,1)-pa(2))+pa(3)*(r(:,2)-pa(4))+pa(5);
    T_mean=mean(tempe_to_fit);
    fun=@(pa,r)pa(1)*sqrt( (r(:,1)-pa(2)).^2+(r(:,2)-pa(3)).^2 ) +T_mean+pa(4);
    pa=lsqcurvefit(fun,pa0,r,tempe_to_fit)
   
    tempe_fit_1=fun(pa,r);
    tempe_fit=zeros(size(tempe_ava));
%     size(tempe_fit_1)
%     length(use_index)
    tempe_fit(use_index)=tempe_fit_1;
    tempe_fit=reshape(tempe_fit,length(Lon),length(Lat));
    tempe_ava=reshape(tempe_ava,length(Lon),length(Lat));
    
    TT=mean(tempe,3);
    land_in=find(TT<2);
    err=abs(tempe_fit-tempe_ava)./abs(tempe_fit);
    err(land_in)=0;
    
    
%     figure
%         imagesc([Lon(1),Lon(end)],[Lat(1),Lat(end)],transpose(tempe_fit));colorbar;hold on;
%         scatter(xx(land_in),yy(land_in),300,'s','MarkerEdgeColor',[.8 .8 .8],...
%                   'MarkerFaceColor',[.8 .8 .8]);hold on;
%         set(gca,'YDir','normal') 
%         set(gcf,'Units','Inches');
%         pos = get(gcf,'Position');
%         set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);  
% %     saveas(gcf,'D:\model\code_co\main\code\tex\image\spatial_distribu_fit.eps','psc2')
%     
%     
%     figure
%         imagesc([Lon(1),Lon(end)],[Lat(1),Lat(end)],transpose(err));colorbar;hold on;
%         scatter(xx(land_in),yy(land_in),300,'s','MarkerEdgeColor',[.8 .8 .8],...
%                   'MarkerFaceColor',[.8 .8 .8]);hold on;
%      
%         set(gca,'YDir','normal') 
%         set(gcf,'Units','Inches');
%         pos = get(gcf,'Position');
%         set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);  
% %     saveas(gcf,'D:\model\code_co\main\code\tex\image\spatial_distribu_fit_err.eps','psc2')
%     
end






