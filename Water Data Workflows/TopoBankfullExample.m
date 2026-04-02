%[text] # Examples
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] 
%%
%[text] ## Topo Toolbox
%[text] ### Load a DEM and display it
%[text] Digital elevation models (DEMs) come in various formats. Most commonly, DEMs are regularly gridded and often are GEOTIFF files. TopoToolbox accepts \*tif-files and ESRI ASCII grids as input to derive a variable of class GRIDobj. Here we use the example DEM that ships with the Toolbox. The DEM covers parts of the San Gabriel Mountains in California USA. It has a pixel spacing (spatial resolution) of 30 m and is projected to the UTM coordinate system. 
%[text] Do you have your own data? Simply change the file address in following code to point to your DEM. This may require absolute file paths (e.g., 'C:/myfiles/.../DEM.tif').
%[text] DEM source: [https://portal.opentopography.org/rasterOutput?jobId=rt1774888808621](https://portal.opentopography.org/rasterOutput?jobId=rt1774888808621) 
DEM = GRIDobj('output_hh.tif');
%[text] You should have a new variable in your workspace called DEM. The variable is an instance of the TopoToolbox class GRIDobj and contains the elevation values as well as information about the projection. 
DEM
%[text] Basic values relating to the DEM can be accessed with the function info.
info(DEM)
%[text] In case you have used your own file, you might get some warning about the projection. Did you supply a DEM with geographic coordinates? Do you have the mapping toolbox? 
%[text] Now let's plot the DEM. TopoToolbox has various functions to do this. Some of these functions are simply overloaded methods. This means, they are functions that are part of MATLAB but that can also be called with a GRIDobj as input.
figure
imagesc(DEM)
h = colorbar;
ylabel(h, 'elevation (m)')
%h.Label.String = 'my label';
%[text] 
%[text] The function surf provides a 3D view of the DEM.
surf(DEM)
camlight
%[text] Is the dark shaded area a hole? Or an error? Let's fix that point.
% indx = DEM.Z<80;
% DEM.Z(indx) = median(DEM.Z,'all');
% 
% figure
% imagesc(DEM)
% h = colorbar;
% h.Label.String = 'Elevation [m]';
%%
%[text] ### Hydrological terrain attributes
%[text] TopoToolbox major strength is in calculating hydrological terrain attributes. These terrain attributes are used to determine the paths of water and sediment through the landscapes. Local flow directions stored as FLOWobj are the basis for the derivation of these terrain attributes. 
%[text] FLOWobj are derived from the DEM. FLOWobj is the name of the class as well as the constructor function.
%DEM = GRIDobj('output_hh.tif');
FD  = FLOWobj(DEM);
%[text] Unlike most GIS software, TopoToolbox requires no preprocessing or hydrological conditioning before calling FLOWobj. Don't fill sinks although there is a function available to do this (fillsinks). FLOWobj will determine closed depressions and derive flow directions in these sinks so that flow paths run along the valley thalwegs as closely as possible. Filling the DEM before would discard the topographic information in topographic depressions that would otherwise constrain the flow paths.
%[text] By default, TopoToolbox calculates single flow directions. Please see the help of FLOWobj for how to calculate multiple flow directions.
%[text] #### Flow accumulation
%[text] Flow accumulation refers to the number of pixels that drain into each pixel. If multiplied by pixel size, flow accumulation equals the drainage or catchment area upstream of each pixel.  The function flowacc calculates flow accumulation and returns a GRIDobj.
A = flowacc(FD);
figure
imageschs(DEM,dilate(sqrt(A),ones(5)),'colormap','flowcolor')
%[text] Drainage basin delineation
%[text] Catchment can be derived using the function drainagebasins. The function returns a GRIDobj with integer values (a label grid).
D = drainagebasins(FD);
imageschs(DEM,shufflelabel(D))
%%
%[text] ## Bankfull Mapper
%[text] Estimate Discharge at Bankfull Stage
%[text] https://topotoolbox.wordpress.com/2025/07/18/bankfullmapper-heres-how-it-works/
%[text] ### Load data
% Load DEM
DEM=GRIDobj("test_data" + filesep + "dem_potenza.tif");
% Load River Course
S=shaperead("test_data" + filesep + "potenza_river.shp");
%%
%[text] REM computation and definition of optional inputs
% Compute REM using HAR function
REM=har(DEM,S);

% plot
figure
imageschs(DEM,REM)
hold on
plot(S.X,S.Y,'w')

% Define optional inputs
% Optional inputs
step=50;        % stepping in meters between transversal river profiles
width=200;      % width in meters of the transversal river profiles
smooth=0;       % smoothing of the planar trace 
max_depth=4;    % maximum height from the thalweg for which bankfull is computed
n=0.05;         % n riverbed roughness coefficient in Manning's equation 

%[text] Extraction of section profiles
% Extract transverse river topographic profiles using PROF function
[d,z,z_dem,x,y,SW]=prof(DEM,REM,S,...
                'step',step,'width',width,...
                'smooth',smooth,'plot',true);
%[text] Hydraulic depth function
% Compute the hydraulic depth function for each profile 
% using BANKFULL function
bank=bankfull(d,z,'max_depth',max_depth);
%[text] Bankfull peak extraction
% LOWEST MODE: the lowest peaks are extracted
lim_low=detect_peak(bank.h,bank.area,bank.width,...
                  bank.elevation,d,z,'peak','lowest');
%[text] River slope computation
% Compute river slope using SECTIONGRADIENT function
ws=10;          % cell windowsize for moving average 
                % computation on slope smoothing 
[slope,~,~,~]=sectiongradient(DEM,SW,step,'windowsize',ws);
%[text] Discharge estimation
% Compute Manning's Equation using MANNINGEQ function
%% MANNING'S EQUATION COMPUTATION 
% (for lowest and max mode extracted peaks)
% discharge computation using the measured peak elevation 
R_low=manningseq(SW,z,z_dem,step,d,lim_low.zlim,'n',n,'slope',slope);
% discharge computation using the most probable elevation 
R_low2=manningseq(SW,z,z_dem,step,d,lim_low.zvar,'n',n,'slope',slope);
% Map Bankfull geometry and discharge using VISUAL function 
% for lowest mode extracted peaks
[f_Zlim_low,f_Zvar_low,f_Qlim_low,f_Qvar_low,...
residual_Z_low,residual_Q_low,res_Z_low,res_Q_low] = ...   
      visual(REM,DEM,SW,step,lim_low.zlim,...
      lim_low.zvar,R_low.Q_zvar,R_low2.Q_zvar,'plot',true);

%[appendix]{"version":"1.0"}
%---
%[metadata:styles]
%   data: {"heading1":{"color":"#268cdd"},"heading2":{"color":"#edb120"},"referenceBackgroundColor":"#333333"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
