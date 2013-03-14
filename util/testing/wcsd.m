function [c,r]=wcsd(x,y,rho,varargin)
%WCSD cross-spectral analysis
%     computation of the integral over the rescaled cross-spectrum
%                     /                        /  /           
%  \Psi(\rho) =  2*N* | P_x(f)*P_y(\rho*f)df  /   | P_x(f)^2+P_y(\rho*f)^2 df
%                    /                       /    /           
%
%                               with  N = \sqrt{(1+\rho^2)/8}*(1/\rho+1)
%
%   [c,r]=wcsd(x,y,rho,fs,...)
%
%   input x,y     x,y time series or power spectral densities 
%                 (see below). y is used as reference, i.e., if
%                 \Psi_{max} is at \rho=1/2, then x contains the half
%                 frequency with respect to y, e.g. x=sin(t), y=sin(2*t).
%                 Thus, y needs to be a vector of length N but x can be a
%                 matrix [N,M], i.e. a set of time series/powers stored
%                 in columns each.
%
%         rho     values for 'rho' (see above)... of course a vector!
%
%         fs      sampling rate (optional)
%                 if fs is given as array, i.e. 
%                        length(fs)==length(x)==length(y), 
%                 then x,y are interpreted as power spectral densities
%                 with identical (!!) frequency axes fs
%                 NOTE: this seems especially useful if you already have the
%                 results of, e.g., SPECTRUM2 because it may safe quite some
%                 computation time 
%
%         options 'plain' (opt. -> switch off mean substraction 
%                                & division by max. amplitude)
%                              ---- this is not recommended ----
%                         ---> ignored if length(fs)>1, see above
%                 'unit' (opt. -> normalize power spectra to max peak=1)
%                 'interp' interpolation type, this must be follow by one of
%                    'nearest' - nearest neighbor interpolation
%                    'linear'  - linear interpolation
%                    'linear*' - fast linear interpolation (works only for
%                                equidistant frequency bins...!!)
%                    'spline'  - cubic spline interpolation (default)
%                    'cubic'   - cubic interpolation
%                 'log' create semilogy plots
%                 'nyquist' followed by a scalar ... evaluate integral up
%                           to that Nyquist frequency (watch out for fs!)
%
%         as usual, without any output argument you get a 'nice' plot
%
%    output c     \Psi (see above) [N,M] matrix
%           r     \rho (see above) vector of length N
%
%                                         (c) 6/99 A. Daffertshofer 
%                                         updates 10/00, 01/01, 05/01
%
%    Remarks(s):
%         - default interpolation has been changed to 'spline'
%         - manual intergration has been replaced by 'trapz'
%         - normalization factor still needs some tests...
%             (watch out for numerical accuracy if \rho approx. 0!!)
%                           for comments... mailto:marlow@fbw.vu.nl
%
%   See also SPECTRUM2, INTERP1, TRAPZ.
error(nargchk(3,11,nargin));
%  
global wcsdremarks;
if isempty(wcsdremarks), wcsdremarks=0; end;
if nargout==0 & wcsdremarks==0,
  wcsdremarks=1;
  beep;
  fprintf(['\nRemarks(s) on ' mfilename ':\n' ...
      '\t- default interpolation has been changed to ''spline''\n' ...
      '\t- manual intergration has been replaced by ''trapz''\n' ...
      '\t- normalization factor still needs some tests...\n' ...
      '\t\t(watch out for numerical accuracy if \rho approx. 0!!)\n' ...
	   '\t\t\t\tfor comments... mailto:marlow@fbw.vu.nl\n\n']);
  beep;
end
%
%interpType='*linear';
interpType='spline';
rescale=[1,0];
logplot=0;
nf=[];
if nargin<4, fs=1; else, fs=varargin{1}; end;
if nargin>4
   for k=2:length(varargin)
      switch lower(varargin{k})
      case 'log', logplot=1;
      case 'plain', rescale(1)=0;
      case 'unit', rescale(2)=1;
      case 'nyquist', 
	 if k==length(varargin)
	    error(['value is missing for option ''' varargin{k} '''']);
	 else
	    nf=varargin{k+1};
	 end
      case 'interp', 
	 if k==length(varargin)
	    error(['value is missing for option ''' varargin{k} '''']);
	 else
	    interpType=varargin{k+1};
	 end
      end
   end
end;
x=squeeze(x);
y=squeeze(y);
rho=rho(:);
num=size(x,2);
if length(fs)==1
   if rescale(1)==1
      x=detrend(x,0);
      y=detrend(y,0); 
      if rescale(2)==0 | nargout==0
         for k=1:num, x(:,k)=x(:,k)/max(abs(x(:,k))); end
         y=y/max(abs(y));
      end;
   end;
   nx=2*size(x,1);
   [px,fx]=spectrum2(x,nx,fix(0.95*nx/2),hamming(fix(nx/2)),fs,'mean');
   ny=2*length(y);
   [py,f0]=spectrum2(y,ny,fix(0.95*nx/2),hamming(fix(ny/2)),fs,'mean');
   n0=min(length(f0),length(fx));
   f0=f0(1:n0);
else
   px=x; py=y; f0=fs;
end

if isempty(nf)==0
   [m,n0]=min(abs(f0-nf)); f0=f0(1:n0);
end

px=px(1:length(f0),:);
py=py(1:length(f0));

if rescale(2)==1
   for k=1:num, px(:,k)=px(:,k)/max(px(:,k)); end
   py=py/max(py);
end
normx=ones(num,1);
%for k=1:num,
%  normx(k)=sum(px(:,k).^2)-(px(1,k)^2+px(end,k)^2)/2;
%end
%normy=sum(py.^2)-(py(1)^2+py(end)^2)/2;
normx=trapz(px.^2,1);
normy=trapz(py.^2);

psi=zeros(length(rho),num);

for l=1:length(rho)
   if rho(l)>=1
      pp=interp1(f0*rho(l),py,f0,interpType);
%      no=(sum(pp.^2)-(pp(1)^2+pp(end)^2)/2);
      no=trapz(pp.^2);
      for k=1:num
%         p=(sum(px(:,k).*pp)-(px(1,k)*pp(1)+px(end,k)*pp(end))/2); 
         p=trapz(px(:,k).*pp);
	 psi(l,k)=2*p/(normx(k)+no);
      end
      psi(l,:)=psi(l,:)*sqrt(1+rho(l)^2)*(1/rho(l)+1)*sqrt(1/8);
   elseif rho(l)>0
      f=f0/rho(l);
      for k=1:num
         pp=interp1(f,px(:,k),f0,interpType);
%         p=sum(pp.*py)-(pp(1)*py(1)+pp(end)*py(end))/2;
%         no=sum(pp.^2)-(pp(1)^2+pp(end)^2)/2; 
         p=trapz(pp.*py);
	 no=trapz(pp.^2);
	 psi(l,k)=2*p/(no+normy);
      end
      psi(l,:)=psi(l,:)*sqrt(1+rho(l)^2)*(1/rho(l)+1)*sqrt(1/8);
   end
end
%
% here comes the nice plot ...
%
if nargout==0
   clf;
   if num==1
      lstrg=['y';'x'];
   else
      lstrg=strcat('x_{',sprintf('%d',(1:num))','}');
      lstrg=[sprintf(['%-' sprintf('%d',size(lstrg,2)) 's'],'y');lstrg];
   end
   l=1;
   if length(fs)==1, 
      rows=3; 
      subplot(rows,1,l); l=l+1;
      h=plot((0:length(y)-1)/fs,y,(0:size(x,1)-1)/fs,x);
      axis tight; 
      legend(h,lstrg);
      if nargin>3, h=xlabel('t [s]'); else, h=xlabel('time'); end
      title('\bf time series');
   else 
      rows=2; 
   end
   subplot(rows,1,l); l=l+1;
   if logplot==0, 
      h=plot(f0,[py,px]); 
   else, 
      h=semilogy(f0,[py,px]); 
      grid on; 
   end;
   axis tight;
   m=max(find(py-max(py)/100>=0));
   for k=1:size(px,2)
      m=max(m,max(find(px(:,k)-max(px(:,k))/100>=0)));
   end
   set(gca,'xlim',[0,min(f0(end),2*f0(m))]);

   legend(h,strcat('P[',lstrg,']'));
   if nargin>3, h=xlabel('f [Hz]'); else, h=xlabel('frequency'); end
   title('\bf power spectral density');
   subplot(rows,1,l); l=l+1;
   if logplot==0, 
      h=plot(rho,psi); 
   else, 
      h=semilogy(rho,psi); 
      grid on; 
   end;
   co=get(gca,'ColorOrder');
   for k=1:num
      set(h(k),'Color',co(mod(k,size(co,1))+1,:))
   end
   axis tight;
   legend(h,strcat('\Psi[',lstrg(2:end,:),']'));
   h=xlabel('\rho');
   title('\bf spectral overlap');
   for k=1:num
      ii=find(psi(:,k)/max(psi(:,k))>0.99);
      yl=get(gca,'ylim');
      for l=1:length(ii)
         if l==1 | ii(l)-ii(l-1)>1
	     for n=3:6
	       ra=rats(rho(ii(l)),n);
	       if isempty(findstr(ra,'*'))==1, break; end;
	     end
	     text(rho(ii(l)),yl(2),['\bf' ra],...
	          'HorizontalAlignment','left','VerticalAlignment', ...
	          'top','Color',co(1+mod(k,size(co,1)),:));
	     line([rho(ii(l)) rho(ii(l))],yl,'LineStyle','-.','Color', ...
		  'k');
	 end
      end
   end
   if exist('niceaxes') ~= 0
      niceaxes(findall(gcf,'Type','axes','Tag',''));
   end
elseif nargout==1
   c=psi;
   m=max(c(:));
   if m>1
      warning(['max. overlap seems to be larger than 1 ...' ...
	       sprintf('[%f]',m)]);
   end
else
   c=psi;
   r=rho;
end







